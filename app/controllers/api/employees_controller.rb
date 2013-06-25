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
    vacations = Employee.find(params[:id])
                         .vacations.where('start_date > ?', Time.current.at_beginning_of_year)

    @json = {'vacation' => 0, 'administrative' => 0, 'license' => 0}
    vacations.each do |v|
      # start_date y end_date son inclusivos
      @json[v.vacation_type] += ((v.end_date.tomorrow.at_beginning_of_day - v.start_date.at_beginning_of_day) / 1.day).to_i
    end

    respond_to do |format|
      format.json { render json: @json }
    end
  end
  
end
