# -*- encoding : utf-8 -*-
class Shift < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :expiration_date, :comments,
                  :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday

  has_and_belongs_to_many :employees

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

  def get_days_array
    [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
  end

  def get_diff_days_array
    actualDif = -6
    if(Time.current.wday != 0)
      actualDif = 1 - Time.current.wday
    end

    days = []
    get_days_array().each_with_index do |day, i|
      if(day)
        days << actualDif + i
      end
    end

    days #lo que devuelve
  end

  def get_days_of_the_week
    diffs = get_diff_days_array
    time = Time.current.midnight

    dates = []

    diffs.each do |diff|
      dates << time + diff.days
    end

    dates #lo que devuelve
  end


  def start_time_for_form
    self.start_time.blank? ? '' : self.start_time.strftime("%I:%M %p")
  end

  def end_time_for_form
    self.end_time.blank? ? '' : self.end_time.strftime("%I:%M %p")
  end
end
