# -*- encoding : utf-8 -*-
require 'modules/utils_lib'
class Assistance < ActiveRecord::Base
  include Modules::UtilsLib
  # start_time: hora de entrada según shift
  # entry_time: hora de entrada real del empleado
  attr_accessible :date, :entry_time, :start_time, :end_time, :exit_time, :employee_id, :shift_id

  belongs_to :shift
  belongs_to :employee

  validates_presence_of :date, :start_time, :end_time

  def get_formatted_date
    get_formatted_day(self.date)
  end

  def get_formatted_entry_time
   self.entry_time ? get_formatted_time(self.entry_time) : 'No ha entrado'
  end

  def get_formatted_start_time
    get_formatted_time(self.start_time)
  end

  def get_formatted_end_time
    get_formatted_time(self.end_time)
  end

  def get_formatted_exit_time
    self.exit_time ? get_formatted_time(self.exit_time) : 'No ha salido'
  end
end
