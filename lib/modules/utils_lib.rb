# -*- encoding : utf-8 -*-
module Modules
  module UtilsLib

      def get_formatted_datetime(datetime)
        datetime.strftime("%d-%m-%Y %H:%M")
      end

      def get_formatted_day(date)
        date.strftime("%d-%m-%Y")
      end

      def get_formatted_time(original_time)
        original_time.strftime("%H:%M")
      end

      def get_time_diff_string(initial_time, final_time)
           time_diff_str(time_diff_array(final_time-initial_time))
      end

      #Método que obtienen un hash con la diferencia temporal en segundos recibida
      def time_diff_array(time_difference)
        days = hours = mins = seconds = 0

        days = (time_difference/(24*60*60)).to_i
        time_difference =  time_difference - days*(24*60*60)

        hours = (time_difference/(60*60)).to_i
        time_difference =  time_difference - hours*(60*60)

        mins = (time_difference/60).to_i
        time_difference =  time_difference - mins*60

        seconds = time_difference.to_i

        delta_hash = [:days => days,:hours => hours,:mins => mins,:seconds => seconds]
        delta_hash[0]
      end


    private
     #Método auxiliar que obtienen un string a partir de un hash de diferencia temporal
     def time_diff_str(delta_hash)
       str = ''
       str += (delta_hash[:days] != 0) ? delta_hash[:days].to_s+' dias ' : ''
       str += (delta_hash[:hours] != 0) ? delta_hash[:hours].to_s+'h ' : ''
       str += (delta_hash[:mins] != 0) ? delta_hash[:mins].to_s+'min ' : ''
       str += (delta_hash[:seconds] != 0) ? delta_hash[:seconds].to_s+'seg' : ''
       if str==''
         str= 'menos de 1 min'
       end
       str
     end
  end
end
