class Limpieza::GeneralController < ApplicationController
  def index
    @next_terminal_cleanups = TerminalCleanup.get_today_instances
    @recent_activity = nil #TODO: Cargar lo que corresponde
    @unfinished_cleanup_requests =  CleanupRequest.get_unfinished
  end
end
