# -*- encoding : utf-8 -*-
class Personal::ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end

  def create
    @shift = Shift.new(params[:shift])
    if(@shift.start_time < @shift.end_time)
      @shift.save
      flash.now[:notice] = 'Turno creado exitosamente'
    else
      flash.now[:error] = 'No se ha podido crear el turno, porque la hora de inicio es después que la hora final'
    end

    @shifts = Shift.all

    render "index"
  end

  def update
  end

  def get_new_shift
    @shift = Shift.new
    @tasks = @shift.get_not_included_task
    @url_form = personal_create_shift_path()
    @name = "nuevo"
    @submit_str = "Crear"

    render personal_shift_form_path
  end
end
