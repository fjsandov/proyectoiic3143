class Limpieza::RoomsViewController < ApplicationController
  def index
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
  end

  def load_zone
    @sectors = Sector.where(:zone => params['zone']).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
    render :json => { "sectors" => @sectors.as_json(:only => [:id, :name]),
                      "rooms" => @rooms.as_json(:only => [:id, :name, :status])}
  end

  def load_sector
    @rooms = Room.where(:sector_id => params['sector']).order(:name)
    render :json => @rooms.to_json(:only => [:id, :name, :status])
  end
end
