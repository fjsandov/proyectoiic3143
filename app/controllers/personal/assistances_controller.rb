# -*- encoding : utf-8 -*-
class Personal::AssistancesController < ApplicationController
  def index
    @date = Time.zone.parse(params[:date]) if params[:date]
    @date = Time.zone.today if @date.nil?

    @shifts = Shift.all
    @shift = Shift.find(params[:shift_id]) unless params[:shift_id].blank?
    if @shift and @shift.active_date_for_shift?(@date)
      # recuperar registros de asistencia
      @assistances = Assistance.where(:date => @date).where(:shift_id => @shift.id)

      # Si no existen, autogenerar registros de asistencia para ese día
      # Nota: Se generan incluso si estan de vacaciones (eso se distingue en la vista)
      if @assistances.length == 0
        @shift.employees.each do |e|
          a = Assistance.create(date: @date, start_time: @shift.start_time, end_time: @shift.end_time,
                                employee_id: e.id, shift_id: @shift.id)
          @assistances << a
        end
      end

      # ordenar asistencia por apellido empleado
      @assistances.sort! { |x,y| x.employee.last_name1 <=> y.employee.last_name1 }
    end
  end

  # POST
  def update
    assistance = ((Assistance.find(params[:id]) if params[:id]) or nil)
    time = params[:time]
    if assistance
      assistance.entry_time = Time.zone.parse(time)
      assistance.save!
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
