# -*- encoding : utf-8 -*-
class CreateShiftsTasks < ActiveRecord::Migration
  def change
    create_table :shifts_tasks do |t|
      t.references :task
      t.references :shift

      t.timestamps
    end
    add_index :shifts_tasks, :task_id
    add_index :shifts_tasks, :shift_id
  end
end
