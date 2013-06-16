# -*- encoding : utf-8 -*-
module ApplicationHelper

  def url_room_by_status(room)
    case room.status
      when 'free'
        limpieza_edit_room_status_path(:id => room.id)
      when 'maintenance'
        limpieza_edit_maintenance_room_path(:id => room.id)
      when 'occupied'
        limpieza_edit_room_status_path(:id => room.id)
      when 'pending'
        cr = CleanupRequest.unfinished_request_of_room(room)
        limpieza_show_cleanup_request_path(:id => cr.id)
      else #when 'cleaning'
        cr = CleanupRequest.unfinished_request_of_room(room)
        limpieza_show_cleanup_request_path(:id => cr.id)
    end
  end

end
