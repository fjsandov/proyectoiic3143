# -*- encoding : utf-8 -*-
class Shift < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :expiration_date,
                  :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday

  has_and_belongs_to_many :employees
  has_and_belongs_to_many :tasks

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
