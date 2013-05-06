class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :string
    add_column :users, :name, :string
    add_column :users, :last_name1, :string
    add_column :users, :last_name2, :string
    add_column :users, :gender, :string
  end
end
