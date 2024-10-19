require 'faker'
require 'json'

# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength
module Integrations
  module Discord
    module Interactions
      class User
        def initialize(
          avatar: nil,
          avatar_decoration_data: nil,
          bot: nil,
          clan: nil,
          discriminator: nil,
          global_name: nil,
          id: nil,
          public_flags: nil,
          system: nil,
          username: nil
        )
          @avatar = avatar
          @avatar_decoration_data = avatar_decoration_data
          @bot = bot
          @clan = clan
          @discriminator = discriminator
          @global_name = global_name || Faker::Internet.username
          @id = id || Faker::Number.number(digits: 18).to_s
          @public_flags = public_flags || Faker::Number.between(from: 0, to: 10)
          @system = system || Faker::Boolean.boolean
          @username = username || Faker::Internet.unique.username
        end

        def to_h
          {
            avatar:,
            avatar_decoration_data:,
            bot:,
            clan:,
            discriminator:,
            global_name:,
            id:,
            public_flags:,
            system:,
            username:
          }
        end

        private

        attr_reader :avatar, :avatar_decoration_data, :bot, :clan, :discriminator,
                    :global_name, :id, :public_flags, :system, :username
      end
    end
  end
end
# rubocop: enable Metrics/MethodLength
# rubocop: enable Metrics/ParameterLists
