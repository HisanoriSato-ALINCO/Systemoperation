class ChangeColumnUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :emp_code, unique: true

  end
end
