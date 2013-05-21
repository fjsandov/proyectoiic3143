class TerminalCleanup < ActiveRecord::Base
  attr_accessible :comments, :interval, :start_date, :end_date, :room_id

  belongs_to :room

  validates_presence_of :interval, :start_date, :room_id


  def self.get_today_instances
    nil  #TODO: esperar a lo que pablo va a hacer con calendario para hacer este metodo
  end

end
