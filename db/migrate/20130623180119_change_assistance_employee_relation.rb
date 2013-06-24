class ChangeAssistanceEmployeeRelation < ActiveRecord::Migration
  def up
    drop_table :assistances_employees
    add_column :assistances, :employee_id, :integer
    add_index :assistances, :employee_id
    add_column :assistances, :shift_id, :integer
    add_index :assistances, :shift_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
