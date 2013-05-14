class Room < ActiveRecord::Base
  attr_accessible :floor, :name, :status, :sector_id, :sector

  belongs_to :sector
  has_many :terminal_cleanups
  has_many :cleanup_requests
  has_many :maintenance_records

  def self.get_cleanup_requestable_rooms
    Room.where('status = ?','free') #TODO: Hacer bien esta consulta. Deben ser las salas sobre las que se puede hacer una solicitud de limpieza
  end
end
