class TerminalCleanupException < ActiveRecord::Base
  attr_accessible :comments, :exception_date, :exception_type, :original_date

  belongs_to :terminal_cleanup
end
