class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
