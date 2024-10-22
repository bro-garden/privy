RSpec.shared_context 'with wrong request headers' do
  let(:wrong_headers) do
    {
      'x-signature-ed25519' => '8447183dce045c137f591757108cc6f475b434591dc198a0715e552f5756bdee1af58efddf30eccc507966404bbc3b0e429baa1154d618330719bbb4b9e5e209',
      'x-signature-timestamp' => '1729617556'
    }
  end
end
