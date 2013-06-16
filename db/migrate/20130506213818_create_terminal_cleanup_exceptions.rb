# -*- encoding : utf-8 -*-
class CreateTerminalCleanupExceptions < ActiveRecord::Migration
  def change
    create_table :terminal_cleanup_exceptions do |t|
      t.references :terminal_cleanup
      t.string :exception_type
      t.date :exception_date
      t.date :original_date
      t.text :comments

      t.timestamps
    end
    add_index :terminal_cleanup_exceptions, :terminal_cleanup_id
    add_index :terminal_cleanup_exceptions, :exception_date
  end
end
