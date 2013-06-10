class CreateAssistances < ActiveRecord::Migration
  def change
    create_table :assistances do |t|
      t.datetime :date
      t.time :start_time
      t.time :entry_time

      t.timestamps
    end
  end
end
