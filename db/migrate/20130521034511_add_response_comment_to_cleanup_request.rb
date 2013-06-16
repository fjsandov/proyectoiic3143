# -*- encoding : utf-8 -*-
class AddResponseCommentToCleanupRequest < ActiveRecord::Migration
  def change
    add_column :cleanup_requests, :response_comments, :text
  end
end
