# -*- encoding : utf-8 -*-
class RenameCommentForMaintenanceRecords < ActiveRecord::Migration
  def up
    rename_column :maintenance_records, :comments, :start_comments
  end

  def down
    rename_column :maintenance_records, :start_comments, :comments
  end
end
