class TerminalCleanup < ActiveRecord::Base
  attr_accessible :comments, :interval, :start_date

  belongs_to :room

  def self.getTodayInstances
    nil           #TODO: esperar a lo que pablo va a hacer con calendario para hacer este metodo
  end
end
