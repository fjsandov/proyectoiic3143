# -*- encoding : utf-8 -*-
class Vacation < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :employee_id, :vacation_type

  validates_presence_of :start_date, :end_date, :vacation_type

  belongs_to :employee

  def is_vacation?
    self.vacation_type == 'vacation'
  end

  # Retorna un bool indicando si el empleado esta en vacaciones, con permiso, o con licencia.
  def self.is_on_vacation?(employee_id, date)
    Vacation.where('employee_id = ? AND (? BETWEEN start_date AND ADDDATE(end_date, 1))', employee_id, date).length > 0
  end

  # Idem a is_on_vacation?, pero retorna el string con el tipo de vacacion.
  def self.is_on_vacation_str(employee_id, date)
    v = Vacation.where('employee_id = ? AND (? BETWEEN start_date AND ADDDATE(end_date, 1))', employee_id, date)
    if v.length > 0
      v[0].vacation_type_str
    else
      nil
    end
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
