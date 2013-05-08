class Limpieza::GeneralController < ApplicationController
  def index
    @next_terminal_cleanups = TerminalCleanup.getTodayInstances
    @recent_activity = nil
    @unfinished_cleanup_requests =  CleanupRequest.getUnfinished
  end
end
