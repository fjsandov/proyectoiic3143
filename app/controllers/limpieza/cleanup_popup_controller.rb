class Limpieza::CleanupPopupController < ApplicationController
  def popup_cleanup_request_new
    @cleanup_request = CleanupRequest.new
    render 'limpieza/popup/cleanup_request_new'
  end

  def create
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])
    if @cleanup_request.create_request(@current_user)
      flash.now[:notice] = 'Solicitud de Limpieza creada exitosamente'
    else
      flash.now[:error] = 'No se ha podido crear la Solicitud de Limpieza'
    end
    render 'limpieza/popup/cleanup_request_new'
  end

  def delete
    @cleanup_request = CleanupRequest.find(params[:cleanup_request][:id])
    if @cleanup_request.delete_request(@current_user)
      flash.now[:notice] = 'Solicitud de Limpieza eliminada exitosamente'
    else
      flash.now[:error] = 'No se ha podido eliminar la Solicitud de Limpieza'
    end
    select_render(@cleanup_request)
  end

  def popup_cleanup_request
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])  #TODO: cargar lo que corresponde
    select_render(@cleanup_request)
  end

  def process_cleanup_request
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])
    if @cleanup_request.status == 'pending'
      process_pending_request(@cleanup_request)
    elsif @cleanup_request.status == 'being-attended'
      process_being_attended_request(@cleanup_request)
    end
    select_render(@cleanup_request)
  end

private
  def select_render(cleanup_request)
    if cleanup_request.state == 'pending'
      render 'limpieza/popup/cleanup_request_response'
    elsif cleanup_request.state == 'being-attended'
      render 'limpieza/popup/cleanup_request_finish'
    elsif cleanup_request.state == 'deleted'
      render 'limpieza/popup/cleanup_request_show'
    end
  end

  def process_pending_request(cleanup_request)
    if cleanup_request.response_request(current_user)
      flash.now[:notice] = 'Se registro el inicio de atencion de la Solicitud de Limpieza'
    else
      flash.now[:error] = 'No se ha podido iniciar la atencion de la Solicitud de Limpieza'
    end
  end

  def process_being_attended_request(cleanup_request)
    if cleanup_request.finish_request(@current_user)
      flash.now[:notice] = 'Solicitud de Limpieza finalizada exitosamente'
    else
      flash.now[:error] = 'No se ha podido finalizar la Solicitud de Limpieza'
    end
  end
end
