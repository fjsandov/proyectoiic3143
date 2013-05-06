class TerminalCleanup < ActiveRecord::Base
  attr_accessible :comments, :interval, :start_date

  belongs_to :room
end
