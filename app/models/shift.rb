# -*- encoding : utf-8 -*-
class Shift < ActiveRecord::Base
  attr_accessible :end_time, :expiration_date, :friday, :monday, :name, :saturday, :start_time, :sunday, :thursday, :tuesday, :wednesday

  has_and_belongs_to_many :employees
  has_and_belongs_to_many :tasks
end
