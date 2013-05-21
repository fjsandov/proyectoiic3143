class AddCommentsToTerminalCleanupInstance < ActiveRecord::Migration
  def change
    add_column :terminal_cleanup_instances, :comments, :text
  end
end
