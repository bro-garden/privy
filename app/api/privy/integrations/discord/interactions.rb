module Privy
  module Integrations
    module Discord
      class Interactions < Grape::API
        desc 'Receive interactions from Bot'
        helpers do
          def user
            user_params = params[:user] || params[:member][:user]

            @user ||= ::Discord::Resources::User.new(
              id: user_params[:id],
              global_name: user_params[:global_name],
              username: user_params[:username]
            )
          end

          def application
            @application ||= ::Discord::Resources::Application.new(id: params[:application_id])
          end

          def guild
            @guild ||= ::Discord::Resources::Guild.new(id: params[:guild_id])
          end

          def interaction
            @interaction ||= ::Discord::Resources::Interaction.new(type: params[:type])
          end

          def raw_body
            request.body.read
          end
        end

        post '/interactions' do
          @resolver = ::Discord::Interactions::Resolvers::Resolver.find(
            interaction:,
            request:,
            raw_body:,
            application:,
            guild:,
            user:
          )
          @resolver.call

          template = "integrations/discord/#{@resolver.name}"
          env['api.tilt.template'] = template
          status :ok
        rescue ::Discord::InvalidSignatureHeader, ::Discord::InvalidGlobalName
          status :unauthorized
          { error: 'unauthorized request' }
        rescue ::Discord::ResolverNotFound, ::Discord::CommandNotSupported, ::Discord::CommandBlank => e
          status :bad_request
          { error: e.message }
        end
      end
    end
  end
end
