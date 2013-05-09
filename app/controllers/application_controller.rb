class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user, :set_controller_and_action, :session_control
  layout :check_if_display_layout
  force_ssl

  def set_controller_and_action
    @current_action = action_name
    @current_controller = controller_name
  end

#---------------------------------------- Session Methods ----------------------------------------
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def session_control
    if !public_sites && !signed_in?
      session_end
      redirect_to :root
    elsif public_sites && signed_in?
      redirect_to :limpieza_general
    end
  end

  def signed_in?
    !@current_user.nil?
  end

  def public_sites
    #Sitios en los que se puede estar sin estar autenticado
    #En Home: (solo logout es reservado para autenticados)
    @is_public_site = (@current_controller=='home' && @current_action != 'logout')
  end

  def session_restart(user)
    session_end
    session_start(user)
  end

  def session_start(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def session_end
    @current_user = nil
    reset_session
  end
#-------------------------------------- AJAX (se envian sin layout) --------------------------------------
  def check_if_display_layout
    if request.xhr?
      false
    elsif @current_user.blank?
      "home"
    else
      "application"
    end
  end
#--------------------------------------------------------------------------------------------------------
end
