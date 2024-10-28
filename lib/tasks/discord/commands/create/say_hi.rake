desc 'Creates /say_hi command'
namespace :discord do
  namespace :commands do
    namespace :create do
      task say_hi: :environment do
        command = DiscordEngine::Commands::SimpleLine.new(name: 'say_hi',
                                                          description: 'just for fun: it says hi to the user')
        creation_response = command.create

        puts "Command created! id: #{JSON.parse(creation_response)['id']}"
      rescue DiscordEngine::CommandCreationFailed => e
        puts e.message
      end
    end
  end
end
