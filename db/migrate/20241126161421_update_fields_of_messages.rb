class UpdateFieldsOfMessages < ActiveRecord::Migration[7.2]
  def change
    rename_column :messages, :read, :expired
    add_column :messages, :expired_at, :datetime, null: true
  end
end
