require 'date'

class Limpieza::CalendarioController < ApplicationController
  # GET /limpieza/calendario
  def index
    @terminal_cleanups = TerminalCleanup.all
  end

  # GET /limpieza/calendario/get_events
  def get_events
    if !params[:start].nil? and !params[:end].nil?
      # Importante usar Time para respetar huso horario
      start_date = Time.at(params[:start].to_i)
      end_date   = Time.at(params[:end].to_i)
      today = Date.today.to_time_in_current_zone
      @events = []

      # Calcular los aseos
      # TODO: Mover esta logica al modelo
      if end_date >= today
        TerminalCleanup.find_each do |tc|
          if tc.start_date < today
            # no mostrar los tc agendados en el pasado
            #current_date = 1.days + tc.start_date + ((today - tc.start_date) % tc.interval.days)
            current_date = tc.start_date
            while current_date < start_date #today
              current_date += tc.interval.days  # TODO: calc. iterativo no es eficiente
            end
          else
            current_date = tc.start_date
          end

          tci_collection = TerminalCleanupInstance.where(:terminal_cleanup_id => tc.id, :original_date => start_date .. end_date)

          while current_date <= end_date
            # check terminal_cleanup_instances
            tci = tci_collection.find { |tc_instance| tc_instance.original_date == current_date }
            if tci
              if tci.instance_date && tci.instance_date <= end_date
                # generado a partir de una instancia
                @events << {
                    :id => "instance-#{tci.id}",
                    :eventType => 'instance',
                    :start => tci.instance_date,
                    :title => tci.terminal_cleanup.room.name,
                    :className => (tci.is_finished ? ' cleanup-instance-finished' : 'cleanup-instance')
                }
              else
                # es una excepcion
              end
            else
              # generado a partir de la regla
              @events << {
                  :id => "rule-#{tc.id}",
                  :eventType => 'rule',
                  :start => current_date,
                  :allDay => true,
                  :title => tc.room.name,
                  :className => 'cleanup-rule'
              }
            end

            current_date += tc.interval.days
          end
        end
      end

      render :json => @events

    else
      render :json => {:error => 'start y end deben estar definidos'}, status: :unprocessable_entity
    end
  end


  # aseos terminales:

  #GET
  def new
    @terminal_cleanup = TerminalCleanup.new
    @requestable_rooms = Room.all
    render 'limpieza/terminal_cleanup_popup/new'
  end

  #POST
  def create
    @terminal_cleanup = TerminalCleanup.new(params[:terminal_cleanup])
    if @terminal_cleanup.save
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      @requestable_rooms = Room.all
      render 'limpieza/terminal_cleanup_popup/new'
    end
  end

  #GET (no utilizado aun)
  def edit
    @terminal_cleanup = TerminalCleanup.find(params[:id])
    #render :json => @terminal_cleanup
    @requestable_rooms = Room.all
    render 'limpieza/terminal_cleanup_popup/edit'
  end

  #PUT (no utilizado aun)
  def update
    @terminal_cleanup = TerminalCleanup.find(params[:terminal_cleanup][:id])
    if @terminal_cleanup.update_attributes(params[:terminal_cleanup])
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      render 'limpieza/terminal_cleanup_popup/edit'
    end
  end


  # terminal cleanup instances :

  #GET
  def new_tc_instance
    @terminal_cleanup = TerminalCleanup.find(params[:tc_id])
    if @terminal_cleanup
      @terminal_cleanup_instance = TerminalCleanupInstance.new
      @terminal_cleanup_instance.terminal_cleanup = @terminal_cleanup
      @terminal_cleanup_instance.original_date = Time.zone.parse("#{params[:tc_year]}-#{params[:tc_month]}-#{params[:tc_day]}")
      @terminal_cleanup_instance.instance_date = Time.current

      render 'limpieza/terminal_cleanup_popup/new_tc_instance'
    else
      render :text => "Aseo terminal #{:tc_id} no encontrado"
    end
  end

  #POST
  def create_tc_instance
    @terminal_cleanup_instance = TerminalCleanupInstance.new(params[:terminal_cleanup_instance])
    # Marcar automaticamente como realizado si es que se fija en el pasado
    @terminal_cleanup_instance.is_finished = @terminal_cleanup_instance.instance_date == nil ||
                                             @terminal_cleanup_instance.instance_date <= Time.current

    if @terminal_cleanup_instance.save
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      render 'limpieza/terminal_cleanup_popup/new_tc_instance'
    end
  end

  #GET
  def edit_tc_instance
    @terminal_cleanup_instance = TerminalCleanupInstance.find(params[:id])
    render 'limpieza/terminal_cleanup_popup/edit_tc_instance'
  end

  #PUT
  def update_tc_instance
    @terminal_cleanup_instance = TerminalCleanupInstance.find(params[:terminal_cleanup_instance][:id])
    if @terminal_cleanup_instance.update_attributes(params[:terminal_cleanup_instance])
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      render 'limpieza/terminal_cleanup_popup/edit_tc_instance'
    end
  end

end
