require 'modules/utils_lib'

class LogRecord < ActiveRecord::Base
  include Modules::UtilsLib

  belongs_to :user
  attr_accessible :message,:user

  def self.get_latest
    LogRecord.limit(30).order('created_at DESC')
  end

  def get_formatted_time
    get_formatted_datetime(self.created_at)
  end

end
