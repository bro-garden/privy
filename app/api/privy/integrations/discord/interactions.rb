module Privy
  module Integrations
    module Discord
      class Interactions < Grape::API
        desc 'Receive interactions from Bot'

        post '/interactions' do
          raw_body = request.body.read
          interaction_request = ::Discord::Interactions::Request.new(params:, headers:, raw_body:)
          @resolver = ::Discord::Interactions::Resolvers::Resolver.create_resolver(request: interaction_request)
          @resolver.call

          template = "integrations/discord/#{@resolver.name}"
          env['api.tilt.template'] = template
          status @resolver.response_status
        end
      end
    end
  end
end
