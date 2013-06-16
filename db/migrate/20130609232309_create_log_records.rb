# -*- encoding : utf-8 -*-
class CreateLogRecords < ActiveRecord::Migration
  def change
    create_table :log_records do |t|
      t.references :user
      t.text :message

      t.timestamps
    end
    add_index :log_records, :user_id
  end
end
