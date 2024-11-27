require 'rails_helper'

RSpec.describe MessageExpirationJob, type: :job do
  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe 'job runs' do
    let!(:message) do
      create(
        :message,
        interface: create(:interface, source: 'discord_guild'),
        external_message: create(:discord_message, channel_id:, external_id:)
      )
    end
    let(:external_id) { '1311101897389768804' }
    let(:channel_id) { '1295855052929630230' }

    it 'changes the message status to expired' do
      VCR.use_cassette('discord_engine/message_expiration/expire_message') do
        expect do
          described_class.perform_now(message.id)
          message.reload
        end.to change(message, :expired).from(false).to(true)
      end
    end

    it 'changes the message expired_at attribute' do
      VCR.use_cassette('discord_engine/message_expiration/expire_message') do
        expect do
          described_class.perform_now(message.id)
          message.reload
        end.to change(message, :expired_at).from(nil)
      end
    end
  end
end
