require 'modules/logger'

class TerminalCleanupInstance < ActiveRecord::Base
  include Modules::Logger

  attr_accessible :instance_date, :updated_by, :comments, :terminal_cleanup_id, :original_date

  belongs_to :terminal_cleanup
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'updated_by'

  validates_presence_of :original_date, :terminal_cleanup_id

  def create_with_log(user)
    message = user.complete_name+' ha guardado como realizado el aseo calendarizado de '+terminal_cleanup.name+
              ' con fecha '+formatted_instance_date
    save_with_log(user,message)
  end

  def formatted_instance_date
    self.instance_date ? self.instance_date.strftime("%d-%m-%Y %I:%M %p") : ''
  end

end