class AddExpirationFieldsToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :expiration_limit, :integer, null: false
    add_column :messages, :expiration_type, :string, null: false
  end
end
