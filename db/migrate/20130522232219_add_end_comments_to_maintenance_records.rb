class AddEndCommentsToMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :end_comments, :string
  end
end
