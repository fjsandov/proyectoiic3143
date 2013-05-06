class TerminalCleanupInstance < ActiveRecord::Base
  attr_accessible :finished_at, :finished_by

  belongs_to :terminal_cleanup
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'finished_by'
end
