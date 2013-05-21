module ApplicationHelper

  def url_room_by_status(room)
    case room.status
      when 'free'
        '/#'
      when 'maintenance'
        '/#'
      when 'occupied'
        '/#'
      when 'pending'
        cr = CleanupRequest.unfinish_request_of_room(room)
        limpieza_show_cleanup_request_path(:id => cr.id)
      else #when 'cleaning'
        cr = CleanupRequest.unfinish_request_of_room(room)
        limpieza_show_cleanup_request_path(:id => cr.id)
    end
  end

end
