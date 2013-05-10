class Limpieza::GeneralController < ApplicationController
  def index
    @next_terminal_cleanups = TerminalCleanup.get_today_instances
    @recent_activity = nil #TODO: Cargar lo que corresponde
    @unfinished_cleanup_requests =  CleanupRequest.get_unfinished
  end

  def popup_cleanup_request_new
    @cleanup_request = CleanupRequest.new
    render 'limpieza/popup/cleanupRequestNew'
  end

  def popup_cleanup_request_response
    @cleanup_request = CleanupRequest.find(params[:id])  #TODO: cargar lo que corresponde
    render 'limpieza/popup/cleanupRequestResponse'
  end

  def popup_cleanup_request_finish
    @cleanup_request = CleanupRequest.find(params[:id])    #TODO: cargar lo que corresponde
    render 'limpieza/popup/cleanupRequestFinish'
  end
end
