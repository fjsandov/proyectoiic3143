# -*- encoding : utf-8 -*-
class Personal::ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end

  def create
    @shift = Shift.new(params[:shift])
    tasks_text = params[:task_list]
    tasks_id = tasks_text[1..tasks_text.size - 1].split(';')
    if(@shift.start_time < @shift.end_time)
      tasks = Task.where(["id in (?)", tasks_id])

      #Se agregan las tareas nuevas
      tasks.each do |task|
        unless @shift.tasks.include?(task)
          @shift.tasks << task
        end
      end
      flash.now[:notice] = 'Turno creado exitosamente'
    else
      flash.now[:error] = 'No se ha podido crear el turno, porque la hora de inicio es después que la hora final'
    end

    redirect_to controller: 'personal/shifts', action: 'index'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash.now[:error] = 'ERROR: No se debe cambiar el formulario'
    else
      if Time.zone.parse(params[:shift][:start_time]) < Time.zone.parse(params[:shift][:end_time])
        @shift = Shift.find(params[:id])
        if @shift.update_attributes(params[:shift])
          tasks_text = params[:task_list]
          tasks_id = tasks_text[1..tasks_text.size - 1].split(';')
          tasks = Task.where(["id in (?)", tasks_id])

          #Se agregan las tareas nuevas
          tasks.each do |task|
            unless @shift.tasks.include?(task)
              @shift.tasks << task
            end
          end

          #Se eliminan las tareas no borradas
          @shift.tasks = @shift.tasks.select {|task| tasks.include? task}
          @shift.save
          flash.now[:notice] = 'Turno actualizado exitosamente'
        else
          flash.now[:error] = 'No se ha podido actualizar el turno'
        end
      else
        flash.now[:error] = 'No se ha podido actualizar el turno, porque la hora de inicio es después que la hora final'
      end
    end

    redirect_to controller: 'personal/shifts', action: 'index'
  end

  def get_new_shift
    @shift = Shift.new
    @tasks = @shift.get_not_included_task
    @url_form = personal_create_shift_path()
    @name = "nuevo turno"
    @submit_str = "Crear"

    render personal_shift_form_path
  end

  def get_shift
    @shift = Shift.find(params[:id]) #me devuelve un arreglo en vez de un shift (magia rails)
    @tasks = @shift.get_not_included_task
    @url_form = personal_update_shift_path(@shift)
    @name = @shift.name
    @submit_str = "Actualizar"
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))

    render personal_shift_form_path
  end
end
