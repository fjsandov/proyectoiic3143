class Room < ActiveRecord::Base
  attr_accessible :floor, :name, :status, :sector_id, :sector

  belongs_to :sector
  has_many :terminal_cleanups
  has_many :cleanup_requests
  has_many :maintenance_records

  #Salas sobre las que se puede realizar una solicitud de limpieza
  def self.get_cleanup_requestable_rooms
    posible_status = ['free','maintenance','occupied']
    Room.where('status in (?)',posible_status)
  end

  def get_status_str
    case self.status
      when 'free'
        'Libre'
      when 'maintenance'
        'En Mantenimiento'
      when 'occupied'
        'Ocupada'
      when 'cleanup-pending'
        'Solicitud pendiente'
      else #when 'being-cleaned'
        'En Limpieza'
    end
  end

end
