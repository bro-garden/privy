class CreateExternalMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :external_messages do |t|
      t.string :type, null: false
      t.string :external_id, null: false
      t.string :channel_id, null: false

      t.timestamps

      t.references :message, null: true, foreign_key: true

      t.index %i[channel_id external_id], unique: true
    end
  end
end
