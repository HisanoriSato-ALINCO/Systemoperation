class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password, :string
    add_column :users, :emp_code, :string
    add_column :users, :emp_name, :string
    add_column :users, :admin_flg, :string
  end
end
