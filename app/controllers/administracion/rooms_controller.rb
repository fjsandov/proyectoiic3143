# -*- encoding : utf-8 -*-
class Administracion::RoomsController < ApplicationController
  def list
    @rooms = Room.get_list_with_search(params[:search]).paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @room = Room.new
    @is_new = true
    render 'room'
  end

  def create
    @room = Room.new(params[:room])

    if @room.save_new_room
      flash[:notice] = 'Sala creada exitosamente'
      redirect_to :administracion_rooms_list
    else
      @is_new = true
      render 'room'
    end
  end

  def edit
    @room = Room.find(params[:id])
    @is_new = false
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
    render 'room'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash[:error] = 'ERROR: No se debe cambiar el formulario'
      redirect_to :administracion_rooms_list
    else
      @room = Room.find(params[:id])

      if @room.update_attributes(params[:room])
        flash.now[:notice] = 'Sala actualizada exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar la sala'
      end
      @is_new = false
      @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      render 'room'
    end
  end
end
