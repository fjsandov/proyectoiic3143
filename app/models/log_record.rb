# -*- encoding : utf-8 -*-
require 'modules/utils_lib'

class LogRecord < ActiveRecord::Base
  include Modules::UtilsLib

  belongs_to :user
  attr_accessible :message,:user

  def self.get_latest
    LogRecord.limit(5).order('created_at DESC')
  end

  def get_formatted_created_at
    if Time.current.to_date == self.created_at.to_date
      get_formatted_time(self.created_at)
    else
      get_formatted_datetime(self.created_at)
    end
  end

end
