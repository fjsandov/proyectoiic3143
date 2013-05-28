class AddRequestTypeToCleanupRequests < ActiveRecord::Migration
  def change
    add_column :cleanup_requests, :request_type, :string
  end
end
