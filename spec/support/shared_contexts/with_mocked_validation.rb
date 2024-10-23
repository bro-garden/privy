RSpec.shared_context 'with mocked validation' do
  let(:validation_result) { true }

  before do
    allow_any_instance_of(
      Discord::Interactions::Resolvers::Resolver
    ).to receive(:valid_signature?).and_return(validation_result)
  end
end
