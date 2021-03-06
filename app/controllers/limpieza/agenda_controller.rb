# -*- encoding : utf-8 -*-
class Limpieza::AgendaController < ApplicationController

  def index
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)
    @date = Time.current  # TODO: deberia ser un parametro (giovanni)
  end

  def get_cleanup_request
    return render(:json => []) if params[:sector].blank?

    sector = Sector.find(params[:sector])
    start_date = Time.zone.at(params[:start].to_i)
    end_date =  Time.zone.at(params[:end].to_i)
    cleanup_requests = CleanupRequest.get_requests_from_sector(sector, start_date, end_date)
    @events = []
    cleanup_requests.each do |cleanup|
      @events << {
          id: "cleanup-#{cleanup.id}",
          start: cleanup.requested_at,
          allDay: false,
          title: cleanup.room.name + ' - ' + cleanup.get_request_type_str + ' : ' + cleanup.start_comments[0..20],
          className: "status-" + cleanup.status,
          popupUrl: limpieza_show_cleanup_request_path(id: cleanup.id),
          cleanupStatus: cleanup.status
      }
    end

    TerminalCleanup.get_instances(start_date, end_date, sector.id).each do |tci|
      @events << {
          id: "tc#{tci[:eventType]}-#{tci[:id]}",
          start: tci[:start],
          allDay: tci[:eventType] != 'instance',
          title: 'Aseo calendarizado: ' + tci[:title],
          className: "terminal-cleanup-#{tci[:eventType]}",
          popupUrl: tci[:eventType] == 'instance' ?
                        limpieza_edit_tc_instance_path + "?id=#{tci[:id]}" :
                        limpieza_new_tc_instance_path + "?tc_id=#{tci[:id]}",
          cleanupStatus: ''
      }
    end

    render :json => @events
  end

  def print_cleanup_requests
    @sectors = Sector.all
  end

  # POST
  def print_cleanup_requests_post
    # El primer elem de sector_id[] es vacio (magia rails >_>)
    if params[:sector_id] && params[:sector_id].count >= 2
      params[:sector_id].delete_at(0)

      params2 = { :sector_id => params[:sector_id], :date => params[:date] }
      @redirect = url_for(:action => :print_cleanup_requests_page) + '?' + params2.to_param
      render 'shared/modal_popup_redirect'
    else
      flash.now[:error] = 'Tiene que seleccionar al menos un sector.'
      @sectors = Sector.all
      render 'limpieza/agenda/print_cleanup_requests'
    end
  end

  def print_cleanup_requests_page
    ids = params[:sector_id].map { |x| x.to_i }
    @date = Time.zone.parse(params[:date])
    @sectors = Sector.where(:id => ids)
    @cleanup_requests = []
    @sectors.each do |s|
      @cleanup_requests[s.id] = CleanupRequest.get_requests_from_sector(s, @date, @date + 1.day)
    end

    render :layout => false
  end

  def import_excel
    begin
      if CleanupRequest.import_excel(@current_user, params[:excel])
        flash[:notice] = 'Se han creado las solicitudes de limpieza exitosamente desde el excel'
      else
        flash[:error] = 'Error al importar excel. Favor revisar formato de
                          archivo y exitencia de las salas en el sistema'
      end
    rescue Exception
      flash[:error] = 'Error al importar excel. Favor revisar formato de
                          archivo y exitencia de las salas en el sistema'
    end

    redirect_to :controller => 'limpieza/agenda', :action => :index
  end
end
