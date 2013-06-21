# -*- encoding : utf-8 -*-
class CreateAssistancesEmployees < ActiveRecord::Migration
  def change
    create_table :assistances_employees do |t|
      t.references :assistance
      t.references :employee

      t.timestamps
    end
    add_index :assistances_employees, :assistance_id
    add_index :assistances_employees, :employee_id
  end
end
