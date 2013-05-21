class AddIsFinishedToTerminalCleanupInstances < ActiveRecord::Migration
  def change
    add_column :terminal_cleanup_instances, :is_finished, :boolean
  end
end
