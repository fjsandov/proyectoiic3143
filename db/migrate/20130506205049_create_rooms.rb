# -*- encoding : utf-8 -*-
class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :floor
      t.string :status
      t.references :sector

      t.timestamps
    end
    add_index :rooms, :sector_id
    add_index :rooms, :floor
    add_index :rooms, :status
  end
end
