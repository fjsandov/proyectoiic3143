# -*- encoding : utf-8 -*-
class Limpieza::RoomsViewController < ApplicationController
  #TODO: Refactoring .. mucha logica en los controladores (usar mas modelo)
  def index
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
  end

  #--------------------------------PARA USUARIO SOLO LECTURA--------------------------------
  def show
    @zones = Sector.select(:zone).group(:zone).order(:name).map { |a| a.zone }
    @sectors = Sector.where(:zone => @zones[0]).order(:name)
    @rooms = Room.where(:sector_id => @sectors[0].id).order(:name)
  end
  #-----------------------------------------------------------------------------------------

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

  def edit_room_status
    @room = Room.find(params[:id])

    render 'limpieza/rooms_view/edit_room_status'
  end

  def change_room_status
    render_view = 'shared/modal_popup_success'
    room = Room.find(params[:req])
    status = params[:room_status]
    if room.status != status
      if room.status == 'free' || room.status == 'occupied'
        if status == 'pending'
          @cleanup_request = CleanupRequest.new(:room_id => room.id)
          @requestable_rooms = Room.get_cleanup_requestable_rooms
          @room_disable = true
          render_view = 'limpieza/cleanup_request_popup/cleanup_request_new'
        else
          room.status = status
          room.save
          if status == 'maintenance'
            maintenance = MaintenanceRecord.new
            maintenance.room_id = room.id
            maintenance.start_comments = params[:maintenance_start_comments]
            maintenance.save
          end
        end
      end
    end

    render render_view
  end

  def edit_maintenance_room
    @room = Room.find(params[:id])
    @maintenance = MaintenanceRecord.get_unfinished_by_room(@room.id)

    render 'limpieza/rooms_view/edit_maintenance_room'
  end

  def finish_maintenance
    @room = Room.find(params[:req])
    @maintenance = MaintenanceRecord.get_unfinished_by_room(@room.id)
    status = params[:room_status]
    if @room.status == 'maintenance'
      if status == 'free' || status == 'occupied'
        @room.status = status
        @maintenance.finished_at = Time.current
        @maintenance.finished_by = @current_user
        @maintenance.end_comments = params[:maintenance_end_comments]

        @room.save
        @maintenance.save
      end
    end

    render 'shared/modal_popup_success'
  end
end
