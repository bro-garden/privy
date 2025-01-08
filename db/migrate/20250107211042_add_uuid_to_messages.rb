class AddUuidToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :uuid, :string
  end
end
