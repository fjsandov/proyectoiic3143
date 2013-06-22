# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user, :set_controller_action_and_module, :session_control,
                :check_if_ajax_request, :check_read_only_user, :check_admin_module
  layout :check_if_display_layout

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
    is_public_site = (@current_controller=='home' && (@current_action == 'login' || @current_action == 'index'))
    is_public_site
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

#-------------------------------------- Authorization methods --------------------------------------
  def check_read_only_user
    if signed_in?
      if @current_user.read_only? && !read_only_sites
        redirect_to :limpieza_show_rooms_readonly and return
      end
    end
  end

  def read_only_sites
    is_read_only_site = @current_controller=='home' && @current_action == 'logout'
    is_read_only_site = is_read_only_site || (@current_controller =='home' && @current_action == 'my_password_change')
    is_read_only_site = is_read_only_site || (@current_controller =='home' && @current_action == 'my_password_update')
    is_read_only_site = is_read_only_site || (@current_controller =='rooms_view' && @current_action == 'show')
    is_read_only_site = is_read_only_site || (@current_controller =='rooms' && @current_action == 'load_zone')
    is_read_only_site = is_read_only_site || (@current_controller =='rooms' && @current_action == 'load_sector')
    is_read_only_site = is_read_only_site || (@current_controller =='logs')
    is_read_only_site = is_read_only_site || (@current_controller == 'errors')
    is_read_only_site
  end

  def check_admin_module
    if @current_module == 'administracion'
      check_admin
    end
  end

  def check_admin
     unless @current_user.admin?
       redirect_to :root and return
     end
  end
#-------------------------------------- AJAX (se envian sin layout) --------------------------------------
  def check_if_ajax_request
    @is_ajax_request = request.xhr?
  end

  def check_if_display_layout
    if request.xhr?
      false
    else
      "application"
    end
  end
#--------------------------------------------------------------------------------------------------------
end
