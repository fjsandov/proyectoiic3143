# -*- encoding : utf-8 -*-
class Vacation < ActiveRecord::Base
  attr_accessible :end_date, :is_vacation, :start_date

  belongs_to :employee
end
