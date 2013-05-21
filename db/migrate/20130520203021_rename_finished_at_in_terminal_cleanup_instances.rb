class RenameFinishedAtInTerminalCleanupInstances < ActiveRecord::Migration
  def change
    rename_column :terminal_cleanup_instances, :finished_at, :instance_date
    rename_column :terminal_cleanup_instances, :finished_by, :updated_by
  end
end
