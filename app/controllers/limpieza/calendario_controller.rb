class Limpieza::CalendarioController < ApplicationController
  def index
  end

  def get_events
    @events = [
        {
            :title => 'event1',
            :start => '2013-05-06'
        },
        {
            :title => 'event2',
            :start => '2013-05-09',
            :end   => '2013-05-11'
        },
        {
            :title => 'event3',
            :start => '2013-05-15 12:30:00',
            :allDay => false # will make the time show
        }
    ]
    render :json => @events
  end

  def create_aseo_terminal
    # TODO
    redirect_to :action => :index
  end
end
