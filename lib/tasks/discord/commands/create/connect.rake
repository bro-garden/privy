desc 'Creates /connect command'
namespace :discord do
  namespace :commands do
    namespace :create do
      task connect: :environment do
        command = DiscordEngine::Commands::SimpleLine.new(name: 'connect',
                                                          description: 'connects privy with discord server')
        creation_response = command.create

        puts "Command created! id: #{JSON.parse(creation_response)['id']}"
      rescue DiscordEngine::CommandCreationFailed => e
        puts e.message
      end
    end
  end
end
