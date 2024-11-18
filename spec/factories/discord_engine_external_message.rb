FactoryBot.define do
  factory :discord_engine_external_message, class: 'DiscordEngine::ExternalMessage' do
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    channel_id { Faker::Alphanumeric.alphanumeric(number: 10) }

    reference_id { create(:message).id }
  end
end
