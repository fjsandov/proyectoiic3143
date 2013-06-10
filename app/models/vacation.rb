class Vacation < ActiveRecord::Base
  attr_accessible :end_date, :is_vacation, :start_date

  belongs_to :employee
end
