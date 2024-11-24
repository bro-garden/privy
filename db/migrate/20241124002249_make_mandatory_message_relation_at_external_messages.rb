class MakeMandatoryMessageRelationAtExternalMessages < ActiveRecord::Migration[7.2]
  def change
    change_column_null :external_messages, :message_id, false
  end
end
