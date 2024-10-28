desc 'Creates /ping command'
namespace :discord do
  namespace :commands do
    task list: :environment do
      response_body = DiscordEngine::Commands::Command.all

      commands = JSON.parse(response_body)
      return puts 'there is no commands' if commands.empty?

      puts 'existing commands:'

      commands.each do |command|
        puts "#{command['id']} type: #{command['type']} name: #{command['name']} description: #{command['description']}"
      end
    rescue DiscordEngine::CommandsIndexFailed => e
      puts e.message
    end
  end
end
