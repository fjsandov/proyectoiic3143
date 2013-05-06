class CreateCleanupRequests < ActiveRecord::Migration
  def change
    create_table :cleanup_requests do |t|
      t.references :room
      t.integer :priority
      t.string :status
      t.text :comments
      t.datetime :requested_at
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :requested_by
      t.integer :started_by
      t.integer :finished_by

      t.timestamps
    end
    add_index :cleanup_requests, :room_id
    add_index :cleanup_requests, :priority
    add_index :cleanup_requests, :status
    add_index :cleanup_requests, :requested_at
    add_index :cleanup_requests, :started_by
    add_index :cleanup_requests, :finished_by
  end
end
