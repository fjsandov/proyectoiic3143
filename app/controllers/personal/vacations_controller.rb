class Personal::VacationsController < ApplicationController
  def index
  end

  # GET (JSON)
  def get_events
    if !params[:start].nil? and !params[:end].nil?
      # Importante usar Time para respetar huso horario
      start_date = Time.at(params[:start].to_i)
      end_date   = Time.at(params[:end].to_i)
      today = Date.today.to_time_in_current_zone
      @events = []

      # Obtener vacaciones
      Vacation.where('start_date <= ?', end_date)
              .where('end_date >= ?', start_date)
              .each do |v|
        @events << {
            :id => "vacation-#{v.id}",
            :eventType => v.is_vacation? ? 'vacation' : 'administrative',
            :start => v.start_date,
            :end => v.end_date,
            :title => v.employee.complete_name,
            :className => v.is_vacation? ? 'cal-vacation' : 'cal-administrative',
        }
      end

      render :json => @events
    else
      render :json => {:error => 'start y end deben estar definidos'}, status: :unprocessable_entity
    end
  end

  #GET
  def new
    @vacation = Vacation.new
    @employees = Employee.all
  end

  #POST
  def create
    @vacation = Vacation.new(params[:vacation])
    if @vacation.save
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el registro'
      @employees = Employee.all
      render 'new'
    end
  end
end
