class AddColumnToExpeople < ActiveRecord::Migration[6.1]
  def change
    add_column :expeople, :ac_code, :string
    add_column :expeople, :ac_name, :string
    add_column :expeople, :sheet_id, :string
    add_column :expeople, :ac_dept, :string
  end
end

