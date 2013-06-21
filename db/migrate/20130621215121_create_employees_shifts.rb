# -*- encoding : utf-8 -*-
class CreateEmployeesShifts < ActiveRecord::Migration
  def change
    create_table :employees_shifts do |t|
      t.references :shift
      t.references :employee

      t.timestamps
    end
    add_index :employees_shifts, :shift_id
    add_index :employees_shifts, :employee_id
  end
end
