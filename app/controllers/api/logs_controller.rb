class Api::LogsController < ApplicationController

  # GET /api/logs/show.json?start=123456790
  def show
    if !params[:start].nil?
      # Importante usar Time para respetar huso horario
      start_date = Time.at(params[:start].to_i)
      @log_records = LogRecord.where('created_at >= ?', start_date).order('created_at DESC')

      respond_to do |format|
        format.json { render json: @log_records }
      end
    else
      render :json => {:error => 'start debe estar definido'}, status: :unprocessable_entity
    end
  end
end
