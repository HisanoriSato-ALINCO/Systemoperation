class ChangeColumnOsystems < ActiveRecord::Migration[6.1]
  def change
    add_index :osystems, :osys_code, unique: true

  end
end
