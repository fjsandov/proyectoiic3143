# -*- encoding : utf-8 -*-
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
