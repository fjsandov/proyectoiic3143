# -*- encoding : utf-8 -*-
class Sector < ActiveRecord::Base
  attr_accessible :name, :zone
  has_many :rooms
end
