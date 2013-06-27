# -*- encoding : utf-8 -*-
class Personal::EmployeesController < ApplicationController
  def list
    @employees = Employee.get_list.search(params[:search]).paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @employee = Employee.new
    @is_new = true
    render 'employee'
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      flash[:notice] = 'Empleado creado exitosamente'
      redirect_to :controller => 'personal/employees', :action => 'list'
    else
      @is_new = true
      render 'employee'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
    @is_new = false
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
    render 'employee'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash[:error] = 'ERROR: No se debe cambiar el formulario'
      redirect_to :controller=>'personal/employees', :action => 'list'
    else
      @employee = Employee.find(params[:id])

      if @employee.update_attributes(params[:employee])
        flash.now[:notice] = 'Empleado actualizado exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar al empleado'
      end
      @is_new = false
      @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      render 'employee'
    end
  end

  def work_history
    @employee = Employee.find(params[:id])
    @employee_work_history = @employee.get_work_history.paginate(:page => params[:page], :per_page => 10)
  end

  def cleaning_history
    @employee = Employee.find(params[:id])
    @employee_cleaning_history = @employee.get_cleaning_history.paginate(:page => params[:page], :per_page => 10)
  end

  def assign_shift
    @employee = Employee.find(params[:id])
    @shifts = Shift.all
  end

  #Ajax
  def get_shifts
    employee = Employee.find(params[:id])
    @shifts = []

    employee.shifts.each do |shift|
      start_times = []
      end_times = []
      started_hour = Time.zone.at(shift.start_time)
      end_hour = Time.zone.at(shift.start_time)
      shift.get_days_of_the_week.each do |day|
        start_times << day + started_hour.hour * 3600 + started_hour.min * 60
        end_times << day + end_hour.hour * 3600 + end_hour.min * 60
      end
      @shifts << {
          id: shift.id,
          allDay: false,
          title: shift.name,
          start_times: start_times,
          end_times: end_times
      }
    end

    render :json => @shifts
  end

  def update_shifts
    @employee = Employee.find(params[:id])
    shifts = Shift.where(["id in (?)", params[:assign_shift_collection]])

    #Se agregan los turnos nuevos
    shifts.each do |shift|
      unless @employee.shifts.include?(shift)
        @employee.shifts << shift
      end
    end

    #Se eliminan los turnos no borrados
    @employee.shifts = @employee.shifts.select {|shift| shifts.include? shift}
    if @employee.save
      flash.now[:notice] = "Lista de turnos actualizada correctamente."
    else
      flash.now[:error] = "Ha ocurrido un error al intentar guardar la lista de turnos"
    end

    redirect_to controller: 'personal/employees', action: 'assign_shift', id: @employee.id
  end

end
