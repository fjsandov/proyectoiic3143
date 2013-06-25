class ChangeVacationTypeInVacation < ActiveRecord::Migration
  def up
    remove_column :vacations, :is_vacation
    add_column :vacations, :vacation_type, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
