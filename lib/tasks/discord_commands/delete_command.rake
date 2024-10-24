desc 'Creates /ping command'
namespace :discord_commands do
  task :delete_command, [:command_id] => [:environment] do |_t, args|
    command_id = args[:command_id]

    if command_id.nil?
      puts "Please set a command_id by running `bundle exec rake discord_commands:delete_command'[command_id]'`"
      next
    end

    bot_token = Rails.application.credentials.discord_application.bot_token
    application_id = Rails.application.credentials.discord_application.id

    response = Discordrb::API.request(
      :applications_aid_commands,
      nil,
      :delete,
      "#{Discordrb::API.api_base}/applications/#{application_id}/commands/#{command_id}",
      Authorization: "Bot #{bot_token}",
    )

    if response.code == 204
      puts "Command with id: #{command_id} deleted!"
    else
      puts "Error: #{response.body}"
    end
  end
end
