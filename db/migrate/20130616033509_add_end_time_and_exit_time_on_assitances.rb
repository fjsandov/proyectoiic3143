# -*- encoding : utf-8 -*-
class AddEndTimeAndExitTimeOnAssitances < ActiveRecord::Migration
  def change
    add_column :assistances, :end_time, :time
    add_column :assistances, :exit_time, :time
  end
end
