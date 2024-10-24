desc 'Creates /ping command'
namespace :discord_commands do
  task list_created_commands: :environment do
    bot_token = Rails.application.credentials.discord_application.bot_token
    application_id = Rails.application.credentials.discord_application.id

    response = Discordrb::API.request(
      :applications_aid_commands,
      nil,
      :get,
      "#{Discordrb::API.api_base}/applications/#{application_id}/commands",
      Authorization: "Bot #{bot_token}",
      content_type: :json
    )

    if response.code == 200
      commands = JSON.parse(response.body)
      return puts 'there is no commands' if commands.empty?

      puts 'existing commands:'

      commands.each do |command|
        puts "#{command['id']} type: #{command['type']} name: #{command['name']} description: #{command['description']}"
      end
    else
      puts "Error: #{response.body}"
    end
  end
end
