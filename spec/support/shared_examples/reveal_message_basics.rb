RSpec.shared_examples 'reval message basics' do
  it 'adds a DiscordEngine::InteractionCallback instance to callback attribute' do
    expect(message_resolver.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
  end

  it 'adds a callback of right type' do
    expect(message_resolver.callback.type)
      .to be(DiscordEngine::InteractionCallback::UPDATE_MESSAGE_TYPE)
  end

  it 'sets empty components array' do
    expect(message_resolver.components).to eq([])
  end
end
