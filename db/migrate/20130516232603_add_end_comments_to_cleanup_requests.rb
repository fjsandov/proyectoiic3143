# -*- encoding : utf-8 -*-
class AddEndCommentsToCleanupRequests < ActiveRecord::Migration
  def change
    add_column :cleanup_requests, :end_comments, :text
    rename_column :cleanup_requests, :comments, :start_comments
  end
end
