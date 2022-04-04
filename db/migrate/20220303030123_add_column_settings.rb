class AddColumnSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :choice_flg, :string
  end
end
