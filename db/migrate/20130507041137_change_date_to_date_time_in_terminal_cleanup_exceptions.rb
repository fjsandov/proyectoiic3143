class ChangeDateToDateTimeInTerminalCleanupExceptions < ActiveRecord::Migration
  def change
    remove_column :terminal_cleanup_exceptions, :exception_date
    add_column :terminal_cleanup_exceptions, :exception_date, :datetime

    remove_column :terminal_cleanup_exceptions, :original_date
    add_column :terminal_cleanup_exceptions, :original_date, :datetime
  end
end
