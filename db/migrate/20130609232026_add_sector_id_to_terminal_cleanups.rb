class AddSectorIdToTerminalCleanups < ActiveRecord::Migration
  def change
    add_column :terminal_cleanups, :sector_id, :integer
    add_index :terminal_cleanups, :sector_id
  end
end
