# -*- encoding : utf-8 -*-
class Limpieza::GeneralController < ApplicationController
  def index
    @next_terminal_cleanups = TerminalCleanup.get_today_instances
    @recent_activity = LogRecord.get_latest
    @unfinished_cleanup_requests =  CleanupRequest.get_unfinished_and_requested
  end
end
