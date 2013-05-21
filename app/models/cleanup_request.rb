require 'modules/utils_lib'

class CleanupRequest < ActiveRecord::Base
  include Modules::UtilsLib
  #Nota: end_comments tiene los comentarios de finish o de delete dependiendo del caso.
  attr_accessible :priority, :status, :room_id, :end_comments,
                  :requested_at, :requested_by, :start_comments,
                  :started_at, :started_by, :response_comments,
                  :finished_at, :finished_by


  belongs_to :room
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'requested_by'
  belongs_to :user, :foreign_key => 'started_by'
  belongs_to :user, :foreign_key => 'finished_by'

  after_save :change_room_status

  ##---------------------VALIDACIONES-------------------##
  validates_presence_of :room_id, :priority, :status

  def self.get_unfinished
    CleanupRequest.where("status = ? or status = ?", "pending", "being-attended")
  end

  def self.priority_options
      [['Baja',3],['Media',2], ['Alta',1]]
  end

  def get_status_str
    case self.status
      when 'pending'
        'Pendiente'
      when 'being-attended'
        'En Limpieza'
      when 'finished'
        'Terminada'
      else #when 'deleted'
        'Eliminada'
    end
  end

  # Entrega "Hoy" y la hora del request en caso de ser el mismo dia de la consulta,
  # y timestamp con dia y hora en caso de no ser del mismo dia de la consulta.
  def get_requested_at_smart_str
    if Time.now.to_date == self.requested_at.to_date
      requested_at.strftime("%H:%M")
    else
      get_formatted_datetime(self.requested_at)
    end
  end

  # Idem al de request pero con started
  def get_started_at_smart_str
    if Time.now.to_date == self.started_at.to_date
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
    end_datetime = Time.now
    unless self.finished_at.blank?
      end_datetime = self.finished_at
    end
    get_time_diff_string(self.started_at, end_datetime)
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

  def create_request(user)
    self.requested_at = Time.parse(self.requested_at.strftime("%d-%m-%Y %I:%M %p"))
    self.status = 'pending'
    self.requested_by = user.id
    self.save
  end

  def delete_request(user)
    #TODO: falta un deleted_by y un deleted_at?
  end

  def response_request(user,employees_assigned)
    self.started_at = Time.now
    self.started_by = user.id
    self.status = 'being-attended'
    self.employees = Employee.where('id in (?)',employees_assigned)
    self.save
  end

  def finish_request(user)
    self.finished_at = Time.now
    self.finished_by = user.id
    self.status = 'finished'
    self.save
  end

  def change_room_status
    case self.status
      when 'pending'
        self.room.status = 'pending'
      when 'being-attended'
        self.room.status = 'cleaning'
      when 'finished'
        self.room.status = 'free'
      else #when 'deleted'
        self.room.status = 'free'
    end
    self.room.save
  end

end
