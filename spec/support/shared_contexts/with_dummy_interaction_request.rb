RSpec.shared_context 'with dummy interaction request' do
  # rubocop: disable RSpec/VerifiedDoubleReference
  let(:request) { instance_double('Request', headers:, params:) } # a dummy Request class
  # rubocop: enable RSpec/VerifiedDoubleReference
end
