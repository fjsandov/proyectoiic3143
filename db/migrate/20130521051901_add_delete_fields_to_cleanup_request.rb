# -*- encoding : utf-8 -*-
class AddDeleteFieldsToCleanupRequest < ActiveRecord::Migration
  def change
    add_column :cleanup_requests, :deleted_by, :integer, references: :users
    add_index :cleanup_requests, :deleted_by
    add_column :cleanup_requests, :deleted_at, :datetime
  end
end
