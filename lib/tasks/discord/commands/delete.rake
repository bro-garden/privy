desc 'Creates /ping command'
namespace :discord do
  namespace :commands do
    task :delete, [:command_id] => [:environment] do |_t, args|
      command_id = args[:command_id]

      if command_id.nil?
        puts "Please set a command_id by running `bundle exec rake discord_commands:delete_command'[command_id]'`"
        next
      end

      DiscordEngine::Commands::Command.destroy(command_id)

      puts "Command with id: #{command_id} deleted!"
    rescue DiscordEngine::CommandDestroyingFailed => e
      puts "Error: #{e.message}"
    end
  end
end
