class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :last_name1
      t.string :last_name2
      t.string :gender
      t.string :religion
      t.string :marital_status
      t.string :spouse_name
      t.string :spouse_occupation
      t.string :education_level
      t.string :birth_date
      t.integer :children
      t.references :occupation
      t.date :joined_at
      t.date :uniform_date
      t.date :equipment_date
      t.boolean :training

      t.timestamps
    end
    add_index :employees, :occupation_id
  end
end
