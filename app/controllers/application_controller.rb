class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user, :set_controller_action_and_module, :session_control, :check_if_ajax_request
  layout :check_if_display_layout
  force_ssl

  def set_controller_action_and_module
    @current_action = action_name
    @current_controller = controller_name
    @current_module = 'home'
    unless params[:controller].index('/').blank?
      @current_module = params[:controller][0,params[:controller].index('/')]
    end
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
  def check_if_ajax_request
    @is_ajax_request = request.xhr?
  end

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
