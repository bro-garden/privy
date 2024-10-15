require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:attributes) { { message: { content:, expiration_limit:, expiration_type: } } }

  describe 'POST /api/temp-messages/temp-messages/messages' do
    let(:content) { 'Hello, world!' }
    let(:expiration_type) { 'days' }

    context 'when the request is valid' do
      let(:expiration_limit) { 10 }

      it 'creates a message' do
        expect { post '/api/temp-messages/messages', params: attributes }.to change(Message, :count).by(1)
      end

      it 'returns a 201 status code' do
        post '/api/temp-messages/messages', params: attributes
        expect(response).to have_http_status(201)
      end

      it "returns a message's url" do
        post '/api/temp-messages/messages', params: attributes
        expect(JSON.parse(response.body)['url']).not_to be_empty
      end
    end

    context 'when the request is invalid' do
      let(:expiration_limit) { 0 }

      it 'does not create a message' do
        expect { post '/api/temp-messages/messages', params: attributes }.not_to change(Message, :count)
      end

      it 'returns a 422 status code' do
        post '/api/temp-messages/messages', params: attributes
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        post '/api/temp-messages/messages', params: attributes
        expect(JSON.parse(response.body)['error']).not_to be_empty
      end
    end
  end
end
