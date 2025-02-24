RSpec.shared_examples 'successful time based message creation' do
  it 'returns true' do
    expect(creator.call).to be_instance_of(Messages::ExpireJob)
  end

  it 'creates a Message instance in message attribute' do
    creator.call
    expect(creator.message).to be_instance_of(Message)
  end

  it 'enqueues a Messages::ExpireJob' do
    expect { creator.call }.to have_enqueued_job(Messages::ExpireJob)
  end
end
