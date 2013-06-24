class ChangeTimeToDatetimeInAssistances < ActiveRecord::Migration
  def up
    remove_column :assistances, :start_time
    remove_column :assistances, :end_time
    remove_column :assistances, :entry_time
    remove_column :assistances, :exit_time

    add_column :assistances, :start_time, :datetime
    add_column :assistances, :end_time, :datetime
    add_column :assistances, :entry_time, :datetime
    add_column :assistances, :exit_time, :datetime
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
