desc 'Creates /say_hi command'
namespace :discord_commands do
  task create_say_hi: :environment do
    bot_token = Rails.application.credentials.discord_application.bot_token
    application_id = Rails.application.credentials.discord_application.id

    command = Discord::Resources::Commands::SimpleLine.new(
      name: 'say_hi',
      description: 'just for fun: it says hi to the user'
    )

    response = Discordrb::API.request(
      :applications_aid_commands,
      nil,
      :post,
      "#{Discordrb::API.api_base}/applications/#{application_id}/commands",
      command.to_json,
      Authorization: "Bot #{bot_token}",
      content_type: :json
    )

    if response.code == 201
      puts "Command created! id: #{JSON.parse(response.body)['id']}"
    else
      puts "Error: #{response.body}"
    end
  end
end
