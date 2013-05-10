class CleanupRequest < ActiveRecord::Base
  attr_accessible :comments, :finished_at, :finished_by, :priority, :requested_at, :requested_by, :started_at,
                  :started_by, :status

  belongs_to :room
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'requested_by'
  belongs_to :user, :foreign_key => 'started_by'
  belongs_to :user, :foreign_key => 'finished_by'

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

  def get_formatted_requested_at
    requested_at.strftime("%d-%m-%Y %H:%M:%S")
  end

  # Entrega la hora del request en caso de ser el mismo dia de la consulta,
  # y timestamp con dia y hora en caso de no ser del mismo dia de la consulta.
  def get_requested_at_time
    if Time.now.to_date == self.requested_at.to_date
      requested_at.strftime("%H:%M")
    else
      get_formatted_requested_at
    end
  end

  def get_priority_class
     'priority-'+self.priority.to_s
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

  def delete_request(user)
    #TODO: falta un deleted_by y un deleted-at?
  end

  def finish_request(user)
    self.finished_at = Time.now
    self.finished_by = user
    self.status = 'finished'
    #TODO: falta guardar los comentarios de finalizacion
  end
end
