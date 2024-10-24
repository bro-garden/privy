class CreateInterfaces < ActiveRecord::Migration[7.0]
  def change
    create_table :interfaces do |t|
      t.string :external_id
      t.integer :interface_type, null: false

      t.timestamps
    end
  end
end
