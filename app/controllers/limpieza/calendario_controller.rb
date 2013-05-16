class Limpieza::CalendarioController < ApplicationController
  # GET /limpieza/calendario
  def index
  end

  # GET /limpieza/calendario/get_events
  def get_events
    if !params[:start].nil? and !params[:end].nil?
      startDate = Time.at(params[:start].to_i).to_datetime
      endDate   = Time.at(params[:end].to_i).to_datetime
      today = DateTime.now.to_date.to_datetime
      @events = []

      # Calcular los aseos futuros
      if (today <= endDate)
        # TODO: Averiguar bien tema de los husos horarios en date/datetime
        # TODO: Terminal_cleanup_exceptions
        TerminalCleanup.find_each do |tc|
          if (tc.start_date <= today)
            first_date = today + ((tc.start_date - today) % tc.interval)
            current_date = first_date
            while current_date < endDate do
              @events << {
                  :id => tc.id,
                  :start => current_date,
                  :allDay => true,
                  :title => tc.room.name,
                  :className => 'calendar-cleanup'
              }
              current_date += tc.interval
            end
          end
        end
      end

      # Ingresar instancias de aseo pasadas
      TerminalCleanupInstance.find_each do |tci|
        if (tci.finished_at >= startDate and tci.finished_at <= endDate)
          @events << {
              :id => tci.id,
              :start => tci.finished_at,
              :title => tci.terminal_cleanup.room.name,
              :className => 'calendar-cleanup-instance'
          }
        end
      end

      render :json => @events

    else
      render :json => {'error' => 'start y end deben estar definidos'}, status: :unprocessable_entity
    end
  end


  def create_aseo_terminal
    # TODO
    redirect_to :action => :index
  end
end
