class Sector < ActiveRecord::Base
  attr_accessible :name, :zone
  has_many :rooms
end
