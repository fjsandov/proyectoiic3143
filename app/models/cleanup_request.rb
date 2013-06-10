require 'modules/utils_lib'

class CleanupRequest < ActiveRecord::Base
  include Modules::UtilsLib
  #Nota: end_comments tiene los comentarios de finish o de delete dependiendo del caso.
  attr_accessible :priority, :status, :room_id, :request_type, :end_comments,
                  :requested_at, :requested_by, :start_comments,
                  :started_at, :started_by, :response_comments,
                  :finished_at, :finished_by,
                  :deleted_by, :deleted_at

  belongs_to :room
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'requested_by'
  belongs_to :user, :foreign_key => 'started_by'
  belongs_to :user, :foreign_key => 'finished_by'
  belongs_to :user, :foreign_key => 'deleted_by'

  after_save :change_room_status

  ##---------------------VALIDACIONES-------------------##
  validates_presence_of :room_id, :priority, :status

  # Método estatico que sera llamado cada 1 minuto. Se encarga de activar solicitudes cuando entra en vigencia
  # y no hay ninguna activa
  def self.activate_requests
    #Busco request inactivas que deberian activarse (por su requested_at)
    inactive_crs = CleanupRequest.where('requested_at < ? and status = ?',Time.current, 'inactive')
    inactive_crs.each do |inactive_cr|
      active_request = CleanupRequest.where('room_id = ? and (status = ? or status = ?)', inactive_cr.room_id,
                           "pending", "being-attended" ).first
      if inactive_cr.room.status == 'maintenance' || !active_request.blank?
        #Hay una solicitud para la sala, y esta "activa" => se borra la solicitud nueva.
        #La sala esta en mantencion => se borra la solicitud nueva.
        inactive_cr.status = 'deleted'
        inactive_cr.deleted_at = Time.current
        inactive_cr.deleted_by = 1 #EL USUARIO QUE LO BORRA ES EL ADMIN.
        comments = 'Solicitud eliminada por el sistema.'
        if inactive_cr.room.status == 'maintenance'
          log_comment = 'Sala estaba en mantencion al momento de intentar activar esta solicitud'
        else
          log_comment= 'Sala tenia solicitudes activas al momento de intentar activar esta solicitud'
        end
        comments += log_comment
        inactive_cr.end_comments = comments,
        message =  "El sistema ha eliminado una Solicitud de Limpieza de la sala " +
                inactive_cr.room.name+". Esto ocurrio porque la "+log_comment
      else
        #Se puede activar sin preocupaciones
        inactive_cr.status = 'pending'
        message = "El sistema ha activado una Solicitud de Limpieza de la sala " +
                inactive_cr.room.name+" pedida por "+ inactive_cr.get_who_requested().complete_name

      end
      inactive_cr.save_with_log(User.find(1), message)
    end
  end

  #Entrega el request sin terminar asociado al room (nil si no existe tal)
  def self.unfinished_request_of_room(room)
    if room.status == 'pending' || room.status == 'cleaning'
      CleanupRequest.where('room_id = ? and (status = ? or status = ?)',room.id, "pending", "being-attended").first
    else
      nil
    end
  end

  #Entrega las solicitudes tanto "Pendiente" como "En Limpieza" cuya fecha de inicio ya paso (evito mostrar
  # las que aun no han sido solicitadas segun la programacion). Se muestran arriba las mas antiguas (esas se
  # deberian tratar de resolver primero)
  def self.get_unfinished_and_requested
    CleanupRequest.get_unfinished.where('requested_at < ?',Time.current).order('requested_at ASC')
  end

  def self.get_unfinished
    CleanupRequest.where("status = ? or status = ?", "pending", "being-attended")
  end

  def self.get_today_request
    CleanupRequest.where("cleanup_requests.status = ? or cleanup_requests.status = ?", "pending", "being-attended").
        where('Date(started_at) = ?', Time.zone.today)
  end

  def self.get_today_request_from_sector(sector)
    CleanupRequest.joins(:room).get_today_request().where('rooms.sector_id' => sector.id)
  end

  def self.priority_options
      [['Baja',3],['Media',2], ['Alta',1]]
  end

  #TODO: ver que este forma de abordar tipos es correcta. Otra idea seria usar prioridad como tipos (reemplazo)
  def self.request_type_options
    [['Rutina','rutine'],['Normal','normal'], ['Terminal','terminal']]
  end

  def get_status_str
    case self.status
      when 'pending'
        'Pendiente'
      when 'being-attended'
        'En Limpieza'
      when 'finished'
        'Terminada'
      when 'deleted'
        'Eliminada'
      else #when inactive
        'Inactiva'
    end
  end

  # Entrega "Hoy" y la hora del request en caso de ser el mismo dia de la consulta,
  # y timestamp con dia y hora en caso de no ser del mismo dia de la consulta.
  def get_requested_at_smart_str
    if Time.current.to_date == self.requested_at.to_date
      requested_at.strftime("%H:%M")
    else
      get_formatted_datetime(self.requested_at)
    end
  end

  # Idem al de request pero con started
  def get_started_at_smart_str
    if Time.current.to_date == self.started_at.to_date
      started_at.strftime("%H:%M")
    else
      self.get_formatted_datetime(self.started_at)
    end
  end

  #Lapso entre que se solicito y se respondio la solicitud:
  def get_waiting_time_str
    get_time_diff_string(self.requested_at, self.started_at)
  end

  #Lapso entre que se comenzo a atender y que se termino la solicitud:
  #NOTA: si no se ha terminado, se toma la hora actual como al de termino
  def get_cleaning_time_str
    end_datetime = Time.current
    unless self.finished_at.blank?
      end_datetime = self.finished_at
    end
    get_time_diff_string(self.started_at, end_datetime)
  end

  def get_request_type_str
    case self.request_type
      when 'rutine'
        'Rutina'
      when 'normal'
        'Normal'
      else #when terminal
        'Terminal'
    end
  end

  def get_priority_str
    case self.priority
      when 1
        'Alta'
      when 2
        'Media'
      else #when 3
        'Baja'
    end
  end

  def get_who_requested
    User.find(self.requested_by)
  end

  def get_who_finished
    User.find(self.finished_by)
  end

  def get_who_deleted
    User.find(self.deleted_by)
  end

  def get_who_started
    User.find(self.started_by)
  end

  def create_request(user)
    self.requested_at = Time.parse(self.requested_at.strftime("%d-%m-%Y %I:%M %p"))
    self.status = 'pending'
    self.requested_by = user.id

    if self.requested_at.between?(Time.current-60,Time.current+60)
      self.requested_at = Time.current
      active_request = CleanupRequest.where('room_id = ? and (status = ? or status = ?)', self.room_id,
                                            "pending", "being-attended" ).first
      if active_request.blank?
        message = user.complete_name+" ha creado una Solicitud de Limpieza para la sala " + self.room.name
        self.save_with_log(user, message)
      else
        self.errors.add(:base, "Ya hay una solicitud de limpieza activa asociada a esta sala")
        false
      end
    else
      self.status = 'inactive' #NOTA: Pasará "solo" a pending cuando el método en config/schedule.rb lo active.
      message = user.complete_name+" ha agendado una Solicitud de Limpieza para la sala " + self.room.name
      self.save_with_log(user, message)
    end
  end

  def delete_request(user)
    self.deleted_at = Time.current
    self.deleted_by = user.id
    self.status = 'deleted'
    message = user.complete_name+" ha eliminado una Solicitud de Limpieza de la sala " + self.room.name
    self.save_with_log(user, message)
  end

  def response_request(user,employees_assigned)
    self.started_at = Time.current
    self.started_by = user.id
    self.status = 'being-attended'
    self.employees = Employee.where('id in (?)',employees_assigned)
    message = user.complete_name+" ha respondido una Solicitud de Limpieza de la sala " + self.room.name
    self.save_with_log(user,message)
  end

  def finish_request(user)
    self.finished_at = Time.current
    self.finished_by = user.id
    self.status = 'finished'
    message = user.complete_name + " ha finalizado una Solicitud de Limpieza de la sala " + self.room.name
    self.save_with_log(user,message)
  end

  def change_room_status
    case self.status
      when 'pending'
        self.room.status = 'pending'
      when 'being-attended'
        self.room.status = 'cleaning'
      when 'finished'
        self.room.status = 'free'
      when 'deleted'
        self.room.status = 'free'
      else #when inactive
        #NO HAGO NADA
    end
    self.room.save
  end

  def save_with_log(user,message)
    if self.save
      LogRecord.create(:user => user,:message => message)
      true
    else
      false
    end
  end

end
