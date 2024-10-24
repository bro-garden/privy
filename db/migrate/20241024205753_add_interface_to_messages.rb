class AddInterfaceToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :interface, foreign_key: true
  end
end
