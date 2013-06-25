# -*- encoding : utf-8 -*-
class Vacation < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :employee_id, :vacation_type

  validates_presence_of :start_date, :end_date, :vacation_type

  belongs_to :employee

  def is_vacation?
    self.vacation_type == 'vacation'
  end

  def vacation_type_str
    case self.vacation_type
      when 'vacation'
        'Vacaciones'
      when 'administrative'
        'Día administrativo'
      when 'license'
        'Licencia'
      else
        self.vacation_type
    end
  end
end
