# -*- encoding : utf-8 -*-
class ChangeDateToDateTimeInTerminalCleanups < ActiveRecord::Migration
  def change
    remove_column :terminal_cleanups, :start_date
    add_column :terminal_cleanups, :start_date, :datetime
  end
end
