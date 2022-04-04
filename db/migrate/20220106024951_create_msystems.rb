class CreateMsystems < ActiveRecord::Migration[6.1]
  def change
    create_table :msystems do |t|

      t.timestamps
    end
  end
end
