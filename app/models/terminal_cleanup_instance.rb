class TerminalCleanupInstance < ActiveRecord::Base
  attr_accessible :instance_date, :updated_by, :comments, :terminal_cleanup_id, :original_date

  belongs_to :terminal_cleanup
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'updated_by'

  validates_presence_of :original_date, :terminal_cleanup_id
end