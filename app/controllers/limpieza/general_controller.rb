class Limpieza::GeneralController < ApplicationController
  def index
    @next_terminal_cleanups = TerminalCleanup.get_today_instances
    @recent_activity = nil #TODO: Cargar lo que corresponde
    @unfinished_cleanup_requests =  CleanupRequest.get_unfinished
  end

  def popup_cleanup_request_response
    @cleanup_request = CleanupRequest.new  #TODO: cargar lo que corresponde
    render 'limpieza/popup/cleanupResponse'
  end

  def popup_cleanup_request_finish
    @cleanup_request = CleanupRequest.new    #TODO: cargar lo que corresponde
    render 'limpieza/popup/cleanupFinish'
  end
end
