# -*- encoding : utf-8 -*-
class CreateMaintenanceRecords < ActiveRecord::Migration
  def change
    create_table :maintenance_records do |t|
      t.references :room
      t.text :comments
      t.datetime :finished_at
      t.integer :finished_by

      t.timestamps
    end
    add_index :maintenance_records, :room_id
    add_index :maintenance_records, :finished_by
  end
end
