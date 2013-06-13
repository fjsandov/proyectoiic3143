class Limpieza::AgendaController < ApplicationController
  def index
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)
    @date = Time.current  # TODO: deberia ser un parametro (giovanni)

    @cleanup_requests = CleanupRequest.get_requests_from_sector(@sectors[0], @date)
  end

  def load_zone
    @sectors = Sector.where(:zone => params['zone']).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
    render :json => { "sectors" => @sectors.as_json(:only => [:id, :name]),
                      "rooms" => @rooms.as_json(:only => [:id, :name, :status])}
  end

  def print_cleanup_requests
    @sectors = Sector.all
  end

  def print_cleanup_requests_page
    @sectors = Sector.where(:sector_id => params[:sector_id])
    @cleanup_requests = []
    @sectors.each do |s|
      @cleanup_requests << CleanupRequest.get_requests_from_sector(s, params[:date])
    end
  end
end
