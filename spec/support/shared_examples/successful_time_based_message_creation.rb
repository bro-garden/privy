RSpec.shared_examples 'successful time based message creation' do
  it 'returns true' do
    expect(creator.call).to be_instance_of(MessageExpirationJob)
  end

  it 'creates a Message instance in message attribute' do
    creator.call
    expect(creator.message).to be_instance_of(Message)
  end

  it 'enqueues a MessageExpirationJob' do
    expect { creator.call }.to have_enqueued_job(MessageExpirationJob)
  end
end
