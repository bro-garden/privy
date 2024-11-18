# This migration comes from discord_engine (originally 20241108221612)
class DiscordEngineCreateExternalMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_engine_external_messages do |t|
      t.string :external_id, null: false
      t.string :channel_id, null: false
      t.integer :reference_id, index: true

      t.timestamps
    end
  end
end
