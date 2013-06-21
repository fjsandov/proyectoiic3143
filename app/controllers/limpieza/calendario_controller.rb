# -*- encoding : utf-8 -*-
require 'date'

class Limpieza::CalendarioController < ApplicationController
  # GET /limpieza/calendario
  def index
    @terminal_cleanups = TerminalCleanup.where('end_date is NULL')
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
      TerminalCleanup.find_each do |tc|
        rule_date = tc.start_date
        if rule_date < today
          # Primera fecha debe ser >= start_date
          while rule_date < start_date
            rule_date += tc.interval.days  # TODO: calc. iterativo no es eficiente
          end
        end

        # Cachear tci para evitar demasiadas consultas
        tci_collection = tc.terminal_cleanup_instances.where(:original_date => start_date .. end_date)

        rule_end_date = (tc.end_date or end_date)
        while rule_date <= rule_end_date
          # check terminal_cleanup_instances
          tci = tci_collection.find { |tc_instance| tc_instance.original_date == rule_date }
          if tci
            if tci.instance_date && tci.instance_date <= end_date
              # generado a partir de una instancia
              @events << {
                  :id => "instance-#{tci.id}",
                  :eventType => 'instance',
                  :start => tci.instance_date,
                  :title => tci.terminal_cleanup.name,
                  :className => ' cleanup-instance-finished'
              }
            else
              # es una excepcion
            end
          else
            # generado a partir de la regla
            @events << {
                :id => "rule-#{tc.id}",
                :eventType => 'rule',
                :start => rule_date,
                :allDay => true,
                :title => tc.name,
                :className => 'cleanup-rule'
            }
          end

          rule_date += tc.interval.days
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
    @terminal_cleanup.start_date = Time.current
    @sectors = Sector.all
    #@requestable_rooms = @sectors.first.rooms
    render 'limpieza/terminal_cleanup_popup/new'
  end

  #POST
  def create
    @terminal_cleanup = TerminalCleanup.new(params[:terminal_cleanup])
    if @terminal_cleanup.save
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      @sectors = Sector.all
      #@requestable_rooms = @sectors.first.rooms
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

  #DELETE
  def destroy
    @terminal_cleanup = TerminalCleanup.find(params[:id])
    @terminal_cleanup.end_date = Time.zone.today

    respond_to do |format|
      if @terminal_cleanup.save
        format.html { redirect_to :action => :index }
        format.json { render 'shared/modal_popup_success' }
      end
    end
  end


  # terminal cleanup instances :

  #GET
  def new_tc_instance
    @terminal_cleanup = TerminalCleanup.find(params[:tc_id])
    if @terminal_cleanup
      @terminal_cleanup_instance = TerminalCleanupInstance.new
      @terminal_cleanup_instance.terminal_cleanup = @terminal_cleanup
      if params[:tc_year] && params[:tc_month] && params[:tc_day]
        @terminal_cleanup_instance.original_date = Time.zone.parse("#{params[:tc_year]}-#{params[:tc_month]}-#{params[:tc_day]}")
      else
        @terminal_cleanup_instance.original_date = Time.zone.today
      end
        @terminal_cleanup_instance.instance_date = Time.current

      render 'limpieza/terminal_cleanup_popup/new_tc_instance'
    else
      render :text => "Aseo terminal #{:tc_id} no encontrado"
    end
  end

  #POST
  def create_tc_instance
    @terminal_cleanup_instance = TerminalCleanupInstance.new(params[:terminal_cleanup_instance])

    if @terminal_cleanup_instance.create_with_log(@current_user)
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
    if @terminal_cleanup_instance.update_with_log(@current_user, params[:terminal_cleanup_instance])
      render 'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido crear el aseo terminal'
      render 'limpieza/terminal_cleanup_popup/edit_tc_instance'
    end
  end

end
