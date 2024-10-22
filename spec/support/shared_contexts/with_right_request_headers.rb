RSpec.shared_context 'with right request headers' do
  let(:right_headers) do
    {
      'x-signature-ed25519' => 'afcb6f0e0c2f19484626051c0cfdb4ce2783a05936a1b7775dce811200f8c3c1e8355300f8f3f1985f065c91eb5f5e3c59e21b05f91447d6a201e13479f91a09',
      'x-signature-timestamp' => '1729617556'
    }
  end
end
