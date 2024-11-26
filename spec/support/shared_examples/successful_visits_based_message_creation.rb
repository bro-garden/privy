RSpec.shared_examples 'successful visits based message creation' do
  it 'returns true' do
    expect(creator.call).to be_nil
  end

  it 'creates a Message instance in message attribute' do
    creator.call
    expect(creator.message).to be_instance_of(Message)
  end

  it 'does not enqueue a MessageExpirationJob' do
    expect { creator.call }.not_to have_enqueued_job(MessageExpirationJob)
  end
end
