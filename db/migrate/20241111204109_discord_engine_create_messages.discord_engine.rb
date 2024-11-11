# This migration comes from discord_engine (originally 20241108221612)
class DiscordEngineCreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_engine_external_messages do |t|
      t.string :external_id, null: false
      t.string :channel_id, null: false
      if DiscordEngine.related_external_messages_table.present?
        t.references DiscordEngine.related_external_messages_table.singularize.underscore.to_sym,
                     foreign_key: { to_table: DiscordEngine.related_external_messages_table },
                     index: true
      end

      t.timestamps
    end
  end
end
