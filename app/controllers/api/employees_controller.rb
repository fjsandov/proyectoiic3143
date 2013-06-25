# -*- encoding : utf-8 -*-
class Api::EmployeesController < ApplicationController
  include ApplicationHelper

  # GET /api/employees/1.json
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.json { render json: @employee }
    end
  end

  # GET /api/employees/1/vacations.json
  # Retorna los dias de vacaciones que ha tomado este empleado desde 01/Enero
  def employee_vacations
    #vacaciones de este año
    vacations = Employee.find(params[:id]).get_vacation_days

    respond_to do |format|
      format.json { render json: vacations }
    end
  end
  
end
