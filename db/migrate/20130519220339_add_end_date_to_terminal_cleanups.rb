# -*- encoding : utf-8 -*-
class AddEndDateToTerminalCleanups < ActiveRecord::Migration
  def change
    add_column :terminal_cleanups, :end_date, :datetime
  end
end
