class Room < ActiveRecord::Base
  attr_accessible :floor, :name, :status

  belongs_to :sector
  has_many :terminal_cleanups
  has_many :cleanup_requests
  has_many :maintenance_records
end
