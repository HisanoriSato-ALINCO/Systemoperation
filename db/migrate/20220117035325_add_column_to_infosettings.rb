class AddColumnToInfosettings < ActiveRecord::Migration[6.1]
  def change
    add_column :infosettings, :set_code, :string
    add_column :infosettings, :iact_code, :string
    add_column :infosettings, :inivalue, :text
    add_column :infosettings, :content, :text
  end
end
