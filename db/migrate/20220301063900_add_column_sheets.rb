class AddColumnSheets < ActiveRecord::Migration[6.1]
  def change
    remove_column :sheets, :a_c_flg, :string
    add_column :sheets, :ac_flg, :string
  end
end
