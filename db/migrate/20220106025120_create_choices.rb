class CreateChoices < ActiveRecord::Migration[6.1]
  def change
    create_table :choices do |t|

      t.timestamps
    end
  end
end
