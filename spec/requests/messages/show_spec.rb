require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  describe 'GET /api/messages/:id' do
    let(:messages) { create_list(:message, 5, interface:) }
    let!(:interface) { create(:interface, source: :api) }

    context 'when the record exists' do
      let(:sample_message) { messages.sample }

      it 'returns ok status' do
        get "/api/messages/#{sample_message.id}"
        expect(response).to have_http_status(:ok)
      end

      it "returns the message's content" do
        get "/api/messages/#{sample_message.id}"
        expect(JSON.parse(response.body)['message']['content']).not_to be_empty
      end
    end

    context 'when the record does not exist' do
      let(:message_id) { 1000 }

      it 'returns status code 404' do
        get "/api/messages/#{message_id}"
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        get "/api/messages/#{message_id}"
        expect(JSON.parse(response.body)['error']).not_to be_empty
      end
    end

    context 'when the record is expired' do
      let(:expired_message) { messages.last }

      before do
        expired_message.update(created_at: 10.years.ago)
      end

      it 'returns status code 401' do
        get "/api/messages/#{expired_message.id}"
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        get "/api/messages/#{expired_message.id}"
        expect(JSON.parse(response.body)['error']).not_to be_empty
      end
    end

    context 'when the record has an invalid expiration type' do
      let(:invalid_message) { messages.last }

      # rubocop:disable Rails/SkipsModelValidations
      before do
        invalid_message.update_column(:expiration_type, 'invalid')
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
