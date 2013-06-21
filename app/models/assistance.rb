# -*- encoding : utf-8 -*-
require 'modules/utils_lib'
class Assistance < ActiveRecord::Base
  include Modules::UtilsLib
  attr_accessible :date, :entry_time, :start_time, :end_time, :exit_time

  has_and_belongs_to_many :employees

  def get_formatted_date
    get_formatted_day(self.date)
  end

  def get_formatted_entry_time
    get_formatted_time(self.entry_time)
  end

  def get_formatted_start_time
    get_formatted_time(self.start_time)
  end

  def get_formatted_end_time
    get_formatted_time(self.end_time)
  end

  def get_formatted_exit_time
    get_formatted_time(self.exit_time)
  end
end
