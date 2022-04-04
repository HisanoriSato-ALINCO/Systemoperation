class ChangeColumnMsystems < ActiveRecord::Migration[6.1]
  def change
    add_index :msystems, :msys_code, unique: true

  end
end
