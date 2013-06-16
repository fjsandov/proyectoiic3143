# -*- encoding : utf-8 -*-
class CreateJoinTables < ActiveRecord::Migration
  def change
    create_table :cleanup_requests_employees, :id => false do |t|
      t.integer :cleanup_request_id
      t.integer :employee_id
    end

    create_table :employees_terminal_cleanups, :id => false do |t|
      t.integer :employee_id
      t.integer :terminal_cleanup_id
    end

  end
end
