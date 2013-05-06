class MaintenanceRecord < ActiveRecord::Base
  attr_accessible :comments, :finished_at

  belongs_to :room
end
