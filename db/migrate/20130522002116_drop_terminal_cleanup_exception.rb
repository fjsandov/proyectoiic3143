class DropTerminalCleanupException < ActiveRecord::Migration
  def up
    drop_table :terminal_cleanup_exceptions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
