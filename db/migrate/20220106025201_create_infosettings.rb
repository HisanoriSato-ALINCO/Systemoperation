class CreateInfosettings < ActiveRecord::Migration[6.1]
  def change
    create_table :infosettings do |t|

      t.timestamps
    end
  end
end
