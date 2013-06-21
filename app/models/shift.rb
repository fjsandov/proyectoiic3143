# -*- encoding : utf-8 -*-
class Shift < ActiveRecord::Base
  attr_accessible :name, :start_time, :end_time, :expiration_date,
                  :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday

  has_and_belongs_to_many :employees
  has_and_belongs_to_many :tasks
end
