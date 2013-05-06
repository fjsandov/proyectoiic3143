class Occupation < ActiveRecord::Base
  attr_accessible :admin_leave_days, :name, :vacation_days

  has_many :employees
end
