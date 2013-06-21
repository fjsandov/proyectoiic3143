# -*- encoding : utf-8 -*-
module Modules
  module Logger

    def save_with_log(user,message)
      if self.save
        LogRecord.create(:user => user,:message => message)
        true
      else
        false
      end
    end

    def log_message(user,message)
      LogRecord.create(:user => user,:message => message)
    end

  end
end


