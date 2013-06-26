# -*- encoding : utf-8 -*-
class Room < ActiveRecord::Base
  attr_accessible :building, :name, :status, :sector_id, :sector

  belongs_to :sector
  has_many :terminal_cleanups
  has_many :cleanup_requests
  has_many :maintenance_records

  validates_uniqueness_of :name
  validates_presence_of :name

  def self.get_list
    Room.joins(:sector).order('CONCAT(sectors.name,rooms.name)')
  end

  def self.count_for_status(target_status)
     Room.find_all_by_status(target_status).count()
  end

  def self.get_cleanup_requestable_rooms
    Room.all
  end

  def self.exist_requestable_rooms?
     !Room.get_cleanup_requestable_rooms.blank?
  end

  def self.sector_options
    Sector.all.collect do |sector|
      [sector.name, sector.id]
    end
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

  def save_new_room
    self.status = 'free'
    self.save
  end

end
