# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  def index
  end

  def login
    if user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
      if user.active?
        session_restart(user)
      else
        flash[:error] = 'Cuenta deshabilitada. Para reactivar debe contactar a Jefe de Servicio de Aseo y Limpieza'
      end
    else
      flash[:error] = 'Revise que su nombre de usuario y contraseña esten escritos correctamente'
    end
    redirect_to :root
  end

  #-------------------------------------- Acciones con sesion iniciada -------------------------------------
  def logout
    session_end
    flash.now[:notice] = 'Sesión terminada'
    render 'index'
  end

  def my_password_change
    @user = @current_user
  end

  def my_password_update
    @user = @current_user
    pass = params[:user][:password]
    pass_conf = params[:user][:password_confirmation]
    if @user.update_attributes(password: pass , password_confirmation: pass_conf)
      flash.now[:notice] = 'Contraseña actualizada exitosamente'
    else
      flash.now[:error] = 'No se ha podido actualizar su contraseña'
    end
    render 'my_password_change'
  end


end
