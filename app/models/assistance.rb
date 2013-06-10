class Assistance < ActiveRecord::Base
  attr_accessible :date, :entry_time, :start_time

  has_and_belongs_to_many :employees
end
