class AddColumnToOsystems < ActiveRecord::Migration[6.1]
  def change
    add_column :osystems, :valid_flg, :string
  end
end
