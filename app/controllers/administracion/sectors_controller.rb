# -*- encoding : utf-8 -*-
class Administracion::SectorsController < ApplicationController
  def list
    @sectors = Sector.get_list.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @sector = Sector.new
    @is_new = true
    @available_zones = Sector.get_available_zones
    render 'sector'
  end

  def create
    @sector = Sector.new(params[:sector])

    if @sector.save
      flash[:notice] = 'Sector creado exitosamente'
      redirect_to :administracion_sectors_list
    else
      @is_new = true
      @available_zones = Sector.get_available_zones
      render 'sector'
    end
  end

  def edit
    @sector = Sector.find(params[:id])
    @is_new = false
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
    @available_zones = Sector.get_available_zones
    render 'sector'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash[:error] = 'ERROR: No se debe cambiar el formulario'
      redirect_to :administracion_sectors_list
    else
      @sector = Sector.find(params[:id])

      if @sector.update_attributes(params[:sector])
        flash.now[:notice] = 'Sector actualizado exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar el sector'
      end
      @is_new = false
      @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      @available_zones = Sector.get_available_zones
      render 'sector'
    end
  end
end
