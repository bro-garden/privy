require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:params) { { message: { content:, expiration_limit:, expiration_type: } } }

  before do
    create(:interface, source: :api, external_id: nil)
    create(:interface, source: :web, external_id: nil)
  end

  describe 'POST /api/messages' do
    let(:content) { 'Hello, world!' }
    let(:expiration_type) { 'days' }

    context 'when the request is valid' do
      let(:expiration_limit) { 10 }

      it 'creates a message' do
        expect { post '/api/messages', params: }.to change(Message, :count).by(1)
      end

      it 'returns a 201 status code' do
        post('/api/messages', params:)
        expect(response).to have_http_status(201)
      end

      it "returns a message's id" do
        post('/api/messages', params:)
        expect(JSON.parse(response.body)['id']).to be_present
      end

      context 'when there are extra parameter' do
        let(:params) do
          { message: { content:, expiration_limit:, expiration_type:, other_parameter: 'any-value' } }
        end

        it 'creates a message' do
          expect { post '/api/messages', params: }.to change(Message, :count).by(1)
        end

        it 'returns a 201 status code' do
          post('/api/messages', params:)
          expect(response).to have_http_status(201)
        end

        it "returns a message's id" do
          post('/api/messages', params:)
          expect(JSON.parse(response.body)['id']).to be_present
        end
      end
    end

    context 'when the request is invalid' do
      context 'when is due to to model validations' do
        let(:expiration_limit) { 0 }

        it 'does not create a message' do
          expect { post '/api/messages', params: }.not_to change(Message, :count)
        end

        it 'returns a 422 status code' do
          post('/api/messages', params:)
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          post('/api/messages', params:)
          expect(JSON.parse(response.body)['error']).not_to be_empty
        end
      end

      context 'when is due to to wrong values' do
        let(:expiration_limit) { 1 }
        let(:expiration_type) { 'not valid' }

        it 'does not create a message' do
          expect { post '/api/messages', params: }.not_to change(Message, :count)
        end

        it 'returns a 400 status code' do
          post('/api/messages', params:)
          expect(response).to have_http_status(400)
        end

        it 'returns an error message' do
          post('/api/messages', params:)
          expect(JSON.parse(response.body)['error']).not_to be_empty
        end
      end

      context 'when a parameter is missing' do
        let(:params) { { message: { expiration_limit:, expiration_type: } } }
        let(:expiration_limit) { 1 }
        let(:expiration_type) { 'day' }

        it 'does not create a message' do
          expect { post '/api/messages', params: }.not_to change(Message, :count)
        end

        it 'returns a 400 status code' do
          post('/api/messages', params:)
          expect(response).to have_http_status(400)
        end

        it 'returns an error message' do
          post('/api/messages', params:)
          expect(JSON.parse(response.body)['error']).not_to be_empty
        end
      end
    end
  end
end
