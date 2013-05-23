require 'modules/utils_lib'

class MaintenanceRecord < ActiveRecord::Base
  include Modules::UtilsLib
  attr_accessible :room_id, :start_comments,:end_comments, :finished_at

  belongs_to :room

  def get_formatted_created_at
    get_formatted_datetime(self.created_at)
  end

  def self.get_unfinished_by_room(room_id)
    MaintenanceRecord.where(:room_id => room_id).where(:finished_at => nil).first
  end
end
