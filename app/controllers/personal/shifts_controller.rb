# -*- encoding : utf-8 -*-
class Personal::ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end

  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      flash.now[:notice] = 'Turno creado exitosamente'
    else
      flash.now[:error] = 'Error al crear el nuevo turno'
    end

    redirect_to controller: 'personal/shifts', action: 'index'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash.now[:error] = 'ERROR: No se debe cambiar el formulario'
    else
      @shift = Shift.find(params[:id])
      if @shift.update_attributes(params[:shift])

        @shift.save
        flash.now[:notice] = 'Turno actualizado exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar el turno'
      end
    end

    redirect_to controller: 'personal/shifts', action: 'index'
  end

  def get_new_shift
    @shift = Shift.new
    @url_form = personal_create_shift_path()
    @name = "nuevo turno"
    @submit_str = "Crear"

    render personal_shift_form_path
  end

  def get_shift
    @shift = Shift.find(params[:id])
    @url_form = personal_update_shift_path(@shift)
    @name = @shift.name
    @submit_str = "Actualizar"
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))

    render personal_shift_form_path
  end
end
