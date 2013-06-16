# -*- encoding : utf-8 -*-
class RemoveIsFinishedFromTerminalCleanupInstances < ActiveRecord::Migration
  def up
    remove_column :terminal_cleanup_instances, :is_finished
  end

  def down
    add_column :terminal_cleanup_instances, :is_finished, :boolean
  end
end
