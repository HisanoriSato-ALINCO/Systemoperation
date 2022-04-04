class CreateOsystems < ActiveRecord::Migration[6.1]
  def change
    create_table :osystems do |t|

      t.timestamps
    end
  end
end
