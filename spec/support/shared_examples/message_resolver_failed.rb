RSpec.shared_examples 'message resolver failed' do
  it 'sets error content' do
    expect(message_resolver.notice.content).to eq(expected_resolver_message)
  end

  it 'still sets the callback' do
    expect(message_resolver.callback).to be_an_instance_of(DiscordEngine::InteractionCallback)
  end

  it 'sets empty components array' do
    expect(message_resolver.notice.components).to eq([])
  end

  it 'sets ephemeral flag' do
    expect(message_resolver.flags).to eq(DiscordEngine::Message::EPHEMERAL_FLAG)
  end

  it 'does not create a message in the database' do
    expect(Message.count).to eq(0)
  end

  it 'does not create a DiscordMessage record' do
    expect(DiscordMessage.count).to eq(0)
  end

  it 'still sets the callback type' do
    expect(message_resolver.callback.type).to eq(DiscordEngine::InteractionCallback::CHANNEL_MESSAGE_WITH_SOURCE_TYPE)
  end
end
