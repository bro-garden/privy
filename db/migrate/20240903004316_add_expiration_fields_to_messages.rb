class AddExpirationFieldsToMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :messages, bulk: true do |t|
      t.integer :expiration_limit, null: false
      t.string :expiration_type, null: false
    end
  end
end
