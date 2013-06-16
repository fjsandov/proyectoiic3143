# -*- encoding : utf-8 -*-
class Room < ActiveRecord::Base
  attr_accessible :floor, :name, :status, :sector_id, :sector

  belongs_to :sector
  has_many :terminal_cleanups
  has_many :cleanup_requests
  has_many :maintenance_records

  validates_uniqueness_of :name

  #Salas sobre las que se puede realizar una solicitud de limpieza
  def self.get_cleanup_requestable_rooms
    #posible_status = ['free','maintenance','occupied']
    #Room.where('status in (?)',posible_status)
    Room.all #TODO: Revisar si basta con que sean todos (y si es necesario)
  end

  def self.exist_requestable_rooms?
     !Room.get_cleanup_requestable_rooms.blank?
  end


  def get_status_str
    case self.status
      when 'free'
        'Libre'
      when 'maintenance'
        'En Mantenimiento'
      when 'occupied'
        'Ocupada'
      when 'pending'
        'Solicitud pendiente'
      else #when 'cleaning'
        'En Limpieza'
    end
  end

end
