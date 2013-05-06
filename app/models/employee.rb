class Employee < ActiveRecord::Base
  attr_accessible :birth_date, :children, :education_level, :equipment_date, :gender, :joined_at, :last_name1, :last_name2,
                  :marital_status, :name, :religion, :spouse_name, :spouse_occupation, :training, :uniform_date

  belongs_to :occupation
  has_and_belongs_to_many :terminal_cleanups
  has_and_belongs_to_many :cleanup_requests
end
