desc 'Creates /message command'

# rubocop: disable Metrics/BlockLength
namespace :discord do
  namespace :commands do
    namespace :create do
      task message: :environment do
        command = DiscordEngine::Commands::ChatInput.new(
          name: 'message',
          description: 'Starts an interaction to create a Privy message'
        )

        command.add_option(
          type: :string,
          name: 'content',
          description: 'Enter the Privy message content',
          required: true
        )

        expiration_type = command.add_option(
          type: :string,
          name: 'expiration_type',
          description: 'Select an expiration type',
          required: true
        )

        %i[hours days visits].each do |type|
          command.add_option_choice(option: expiration_type, name: type.to_s, value: type)
        end

        expiration_limit = command.add_option(
          type: :integer,
          name: 'expiration_limit',
          description: 'Choose an expiration limit',
          required: true
        )

        [1, 2, 3, 4, 5].each do |limit|
          command.add_option_choice(option: expiration_limit, name: limit.to_s, value: limit)
        end

        creation_response = command.create

        puts "Command created! ID: #{JSON.parse(creation_response)['id']}"
      rescue DiscordEngine::CommandCreationFailed => e
        puts e.message
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength

Rake::Task['discord_engine:commands:create'].enhance do
  Rake::Task['discord:commands:create:message'].invoke
end
