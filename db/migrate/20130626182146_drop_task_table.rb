class DropTaskTable < ActiveRecord::Migration
  def up
    drop_table :shifts_tasks
    drop_table :tasks
    add_column :shifts, :comments, :text
  end

  def down

  end
end
