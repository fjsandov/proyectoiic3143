# -*- encoding : utf-8 -*-
class Administracion::UsersController < ApplicationController
  def list
    @users = User.paginate(:page => params[:page], :per_page => 10)
    render 'index'
  end

  def new
    @user = User.new
    @is_new = true
    render 'user'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'Usuario creado exitosamente'
      redirect_to :administracion_users_list
    else
      @is_new = true
      render 'user'
    end
  end

  def edit
    @user = User.find(params[:id])
    @is_new = false
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
    render 'user'
  end

  def update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash[:error] = 'ERROR: No se debe cambiar el formulario'
      redirect_to :administracion_users_list
    else
      @user = User.find(params[:id])

      if @user.update_attributes(params[:user])
        flash.now[:notice] = 'Usuario actualizado exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar al usuario'
      end
      @is_new = false
      @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      render 'user'
    end
  end

  def password_change
    @user = User.find(params[:id])
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
  end

  def password_update
    if params[:sec] != Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      flash[:error] = 'ERROR: No se debe cambiar el formulario'
      redirect_to :administracion_users_list
    else
      @user = User.find(params[:id])
      pass = params[:user][:password]
      pass_conf = params[:user][:password_confirmation]
      if @user.update_attributes(password: pass , password_confirmation: pass_conf)
        flash.now[:notice] = 'Contraseña de usuario actualizada exitosamente'
      else
        flash.now[:error] = 'No se ha podido actualizar la contraseña del usuario'
      end
      @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))
      render 'password_change'
    end
  end
end
