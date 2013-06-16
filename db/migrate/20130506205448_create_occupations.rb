# -*- encoding : utf-8 -*-
class CreateOccupations < ActiveRecord::Migration
  def change
    create_table :occupations do |t|
      t.string :name
      t.integer :vacation_days
      t.integer :admin_leave_days

      t.timestamps
    end
  end
end
