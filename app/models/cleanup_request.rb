class CleanupRequest < ActiveRecord::Base
  attr_accessible :comments, :finished_at, :finished_by, :priority, :requested_at, :requested_by, :started_at,
                  :started_by, :status

  belongs_to :room
  has_and_belongs_to_many :employees
  belongs_to :user, :foreign_key => 'requested_by'
  belongs_to :user, :foreign_key => 'started_by'
  belongs_to :user, :foreign_key => 'finished_by'

  def self.getUnfinished
    CleanupRequest.where("status != ?", "finished")
  end

end
