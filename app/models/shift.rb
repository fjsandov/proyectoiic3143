# -*- encoding : utf-8 -*-
class Shift < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :expiration_date,
                  :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday

  has_and_belongs_to_many :employees
  has_and_belongs_to_many :tasks

  # true si en 'date' está vigente este shift
  def active_date_for_shift?(date)
    false unless date.is_a?(Date) or date.is_a?(Time) or date.is_a?(DateTime)
    case date.wday
      when 0 then return sunday
      when 1 then return monday
      when 2 then return tuesday
      when 3 then return wednesday
      when 4 then return thursday
      when 5 then return friday # FUN! FUN! FUN!
      when 6 then return saturday
    end
  end

  #Obtengo las tareas que no están incluidas en el turno
  def get_not_included_task
    if self.tasks.any?
      return Task.where(["tasks.id not in (?)",self.tasks.map(&:id)])
    else
      return Task.all
    end
  end

  def start_time_for_form
    self.start_time.blank? ? '' : self.start_time.strftime("%I:%M %p")
  end

  def end_time_for_form
    self.end_time.blank? ? '' : self.end_time.strftime("%I:%M %p")
  end
end
