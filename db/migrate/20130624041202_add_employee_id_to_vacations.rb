class AddEmployeeIdToVacations < ActiveRecord::Migration
  def change
    add_column :vacations, :employee_id, :integer
    add_index :vacations, :employee_id
  end
end
