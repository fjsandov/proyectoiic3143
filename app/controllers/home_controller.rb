class HomeController < ApplicationController
  def index
  end

  def login
    if user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
      if user.active?
        session_restart(user)
        success = true
      else
        flash[:error] = "Cuenta deshabilitada. Para reactivar contactar a Jefe de Servicio de Aseo y Limpieza"
        success = false
      end
    else
      flash[:error] = "Revise que su nombre de usuario y contrasena esten escritos correctamente "
      success = false
    end

    (success) ? (redirect_to :limpieza_general) : (redirect_to :root)
  end

  def logout
    session_end
    flash[:notice] = "Sesion terminada."
    redirect_to :root
  end


end
