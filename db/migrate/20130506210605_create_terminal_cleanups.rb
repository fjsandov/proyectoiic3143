# -*- encoding : utf-8 -*-
class CreateTerminalCleanups < ActiveRecord::Migration
  def change
    create_table :terminal_cleanups do |t|
      t.references :room
      t.date :start_date
      t.integer :interval
      t.text :comments

      t.timestamps
    end
    add_index :terminal_cleanups, :room_id
  end
end
