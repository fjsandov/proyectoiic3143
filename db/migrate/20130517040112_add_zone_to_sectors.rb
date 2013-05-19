class AddZoneToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :zone, :string, :null => false
  end
end
