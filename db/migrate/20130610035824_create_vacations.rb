class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_vacation

      t.timestamps
    end
  end
end
