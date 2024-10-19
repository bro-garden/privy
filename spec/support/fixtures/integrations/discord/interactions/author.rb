require 'faker'
require 'json'

module Integrations
  module Discord
    module Interactions
      class Author
        def initialize
          @avatar = nil
          @avatar_decoration_data = nil
          @clan = nil
          @discriminator = '0'
          @global_name = Faker::Internet.username
          @id = Faker::Number.number(digits: 18).to_s
          @public_flags = Faker::Number.between(from: 0, to: 10)
          @username = Faker::Internet.username
        end

        def to_h
          {
            avatar:,
            avatar_decoration_data:,
            clan:,
            discriminator:,
            global_name:,
            id:,
            public_flags:,
            username:
          }
        end

        private

        attr_reader :avatar, :avatar_decoration_data, :clan, :discriminator, :global_name, :id, :public_flags, :username
      end
    end
  end
end
