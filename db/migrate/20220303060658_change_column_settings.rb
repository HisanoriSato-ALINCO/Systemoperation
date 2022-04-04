class ChangeColumnSettings < ActiveRecord::Migration[6.1]
  def change
    add_index :settings, :set_code, unique: true

  end
end
