RSpec.shared_examples 'unauthorizable request' do
  context 'when signature is invalid' do
    include_context 'with mocked validation'

    let(:validation_result) { false }

    it 'returns a 401 status code for invalid signature' do
      post(endpoint, params:)
      expect(response).to have_http_status(401)
    end

    it 'returns empty body for invalid request' do
      post(endpoint, params:)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'unauthorized request' })
    end
  end
end
