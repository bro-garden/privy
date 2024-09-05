class CreateMessageVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :message_visits do |t|
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
