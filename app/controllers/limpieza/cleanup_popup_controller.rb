class Limpieza::CleanupPopupController < ApplicationController
  def popup_cleanup_request_new
    @cleanup_request = CleanupRequest.new
    @requestable_rooms = Room.get_cleanup_requestable_rooms
    render 'limpieza/cleanup_request_popup/cleanup_request_new'
  end

  def create
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])
    @requestable_rooms = Room.get_cleanup_requestable_rooms

    if @cleanup_request.create_request(@current_user)
      flash.now[:notice] = 'Se ha creado la Solicitud de Limpieza exitosamente'
      if params[:submit_type]=='just_create'
        render 'shared/modal_popup_success'
      else
        @cleanup_request = CleanupRequest.new
        render 'limpieza/cleanup_request_popup/cleanup_request_new'
      end
    else
      flash.now[:error] = 'No se ha podido crear la Solicitud de Limpieza'
      render 'limpieza/cleanup_request_popup/cleanup_request_new'
    end
  end

  #Dependiendo del estado de la solicitud, renderea distintos modal popup:
  def popup_cleanup_request_show
    @cleanup_request = CleanupRequest.find(params[:id])
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(params[:id]))

    if @cleanup_request.status == 'pending'
      render 'limpieza/cleanup_request_popup/cleanup_request_response'
    elsif @cleanup_request.status == 'being-attended'
      render 'limpieza/cleanup_request_popup/cleanup_request_finish'
    elsif @cleanup_request.status == 'deleted'
      render 'limpieza/cleanup_request_popup/cleanup_request_show'
    end
  end

  #SUPUESTO: Se asume que solo se puede llamar a procesamiento a aquellas solicitudes que estan
  #          Pendientes o En Limpieza.
  def process_cleanup_request
    render_view = 'shared/modal_popup_success'
    #NOTA: hidden con id de cleanup_request se comprueba que no fue modificado con el secreto adjunto (mas dificil de modificar)
    hacking_attempt = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(params[:req])) != params[:sec]
    unless hacking_attempt
      @cleanup_request = CleanupRequest.find(params[:req])
      @cleanup_request.end_comments = params[:end_comments]

      if params[:submit_type]=='delete'
        render_view = delete(@cleanup_request)
      else
        if @cleanup_request.status == 'pending'
          render_view = process_pending_request(@cleanup_request,params[:employees_assigned])
        elsif @cleanup_request.status == 'being-attended'
          render_view = process_being_attended_request(@cleanup_request)
        end
      end
    end
    render render_view
  end

private
  def process_pending_request(cleanup_request,employees_assigned)
    if cleanup_request.response_request(current_user,employees_assigned)
      flash[:notice] = 'Se ha respondido a la Solicitud de Limpieza exitosamente'
      'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido responder a la Solicitud de Limpieza'
      'limpieza/cleanup_request_popup/cleanup_request_response'
    end
  end

  def process_being_attended_request(cleanup_request)
    if cleanup_request.finish_request(@current_user)
      flash[:notice] = 'Se ha finalizado la Solicitud de Limpieza exitosamente'
      'shared/modal_popup_success'
    else
      flash.now[:error] = 'No se ha podido finalizar la Solicitud de Limpieza'
      'limpieza/cleanup_request_popup/cleanup_request_finish'
    end
  end

  def delete(cleanup_request)
    if cleanup_request.delete_request(@current_user)
      flash[:notice] = 'Se ha eliminado la Solicitud de Limpieza exitosamente'
      'shared/modal_popup_success'
    else
      @cleanup_request = cleanup_request
      flash.now[:error] = 'No se ha podido eliminar la Solicitud de Limpieza'
      if cleanup_request.status == 'being-attended'
        'limpieza/cleanup_request_popup/cleanup_request_finish'
      else #cleanup_request.status == 'pending'
        'limpieza/cleanup_request_popup/cleanup_request_response'
      end
    end
  end
end