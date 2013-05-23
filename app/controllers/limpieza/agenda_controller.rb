class Limpieza::AgendaController < ApplicationController
  def index
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)

    @cleanup_requests = CleanupRequest.get_today_request_from_sector(@sectors[0])
  end

  def load_zone
    @sectors = Sector.where(:zone => params['zone']).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
    render :json => { "sectors" => @sectors.as_json(:only => [:id, :name]),
                      "rooms" => @rooms.as_json(:only => [:id, :name, :status])}
  end
end
