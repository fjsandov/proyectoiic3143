class AddOriginalDateToTerminalCleanupInstances < ActiveRecord::Migration
  def change
    add_column :terminal_cleanup_instances, :original_date, :datetime
  end
end
