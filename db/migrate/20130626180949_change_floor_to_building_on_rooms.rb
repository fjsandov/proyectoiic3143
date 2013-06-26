class ChangeFloorToBuildingOnRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :floor
    add_column :rooms, :building, :string
  end
end
