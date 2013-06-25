# -*- encoding : utf-8 -*-
class Sector < ActiveRecord::Base
  attr_accessible :name, :zone
  has_many :rooms

  validates_presence_of :name, :zone
  validates_uniqueness_of :name

  def self.get_list
    Sector.order(:zone)
  end

  def self.get_available_zones
    Sector.group(:zone)
  end
end
