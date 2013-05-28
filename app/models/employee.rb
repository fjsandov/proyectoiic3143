class Employee < ActiveRecord::Base
  attr_accessible :birth_date, :children, :education_level, :equipment_date, :gender, :joined_at,
                  :last_name1, :last_name2, :marital_status, :name, :religion, :spouse_name, :spouse_occupation,
                  :training, :uniform_date

  belongs_to :occupation
  has_and_belongs_to_many :terminal_cleanups
  has_and_belongs_to_many :cleanup_requests

  def self.on_turn_employees  #TODO: Que en verdad sean los que estan de turno
     Employee.all
  end

  def self.on_turn_employees_for_select
    self.on_turn_employees.collect do |employee|
      [employee.complete_name, employee.id]
    end
  end

  def complete_name
    cn = self.name
    unless self.last_name1.blank?
      cn = cn + ' ' +self.last_name1
      unless self.last_name2.blank?
        cn = cn + ' ' + self.last_name2
      end
    end
    cn
  end
end
