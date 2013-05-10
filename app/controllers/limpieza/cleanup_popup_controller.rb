class Limpieza::CleanupPopupController < ApplicationController
  def create
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])
    @cleanup_request.save
  end

  def process_finish

  end

  def process_response

  end

  def delete
    @cleanup_request = CleanupRequest.find(params[:cleanup_request][:id])
    @cleanup_request.finish(@current_user)
  end
end
