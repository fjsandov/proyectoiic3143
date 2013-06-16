# -*- encoding : utf-8 -*-
class Personal::EmployeesController < ApplicationController
  def list
    @employees = Employee.all
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

end
