# -*- encoding : utf-8 -*-
class CreateTerminalCleanupInstances < ActiveRecord::Migration
  def change
    create_table :terminal_cleanup_instances do |t|
      t.references :terminal_cleanup
      t.datetime :finished_at
      t.integer :finished_by

      t.timestamps
    end
    add_index :terminal_cleanup_instances, :terminal_cleanup_id
    add_index :terminal_cleanup_instances, :finished_by
  end
end
