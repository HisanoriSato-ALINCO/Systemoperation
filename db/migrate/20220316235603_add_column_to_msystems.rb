class AddColumnToMsystems < ActiveRecord::Migration[6.1]
  def change
    add_column :msystems, :valid_flg, :string
  end
end
