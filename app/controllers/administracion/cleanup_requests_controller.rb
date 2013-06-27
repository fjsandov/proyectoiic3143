class Administracion::CleanupRequestsController < ApplicationController
  def list
    @cleanup_requests = CleanupRequest.get_closed.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @cleanup_request = CleanupRequest.find(params[:id])
  end
end
