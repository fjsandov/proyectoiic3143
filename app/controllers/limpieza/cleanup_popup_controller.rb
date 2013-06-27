# -*- encoding : utf-8 -*-
class Limpieza::CleanupPopupController < ApplicationController
  def popup_cleanup_request_new
    @cleanup_request = CleanupRequest.new
    @room_disable = false
    @sectors = Sector.all
    render 'limpieza/cleanup_request_popup/cleanup_request_new'
  end

  def create
    @cleanup_request = CleanupRequest.new(params[:cleanup_request])
    @sectors = Sector.all

    #Si se pide para ahora, se deja en nil el campo.
    if params[:now_check] == 'on'
      @cleanup_request.requested_at = nil
    end

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
    @sec = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:id]))

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
    #NOTA: hidden con id de cleanup_request se comprueba que no fue modificado con el secreto adjunto
    #      (mas dificil de modificar)
    secret_value = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@current_user.id.to_s+'_'+params[:req]))
    hacking_attempt =  secret_value != params[:sec]
    unless hacking_attempt
      @cleanup_request = CleanupRequest.find(params[:req])

      if params[:submit_type]=='delete'
        @cleanup_request.end_comments = params[:comments]
        render_view = delete(@cleanup_request)
      else
        if @cleanup_request.status == 'pending'
          @cleanup_request.response_comments = params[:comments]
          render_view = process_pending_request(@cleanup_request,params[:employees_assigned])
        elsif @cleanup_request.status == 'being-attended'
          @cleanup_request.end_comments = params[:comments]
          to_maintenance = params[:submit_type]=='finish_and_maintenance'
          render_view = process_being_attended_request(@cleanup_request,to_maintenance)
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

  def process_being_attended_request(cleanup_request,to_maintenance)
    if cleanup_request.finish_request(@current_user)
      if to_maintenance
        cleanup_request.room.status = 'maintenance'
        cleanup_request.room.save
        MaintenanceRecord.create(:room_id => cleanup_request.room_id, :start_comments => cleanup_request.end_comments)
      end
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
