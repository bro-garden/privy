module Privy
  module Integrations
    module Discord
      class Interactions < Grape::API
        desc 'Receive interactions from Bot'
        helpers do
          def user
            @user ||= ::Discord::Resources::User.new(id: params[:user][:id], global_name: params[:user][:global_name],
                                                     username: params[:user][:username])
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
        rescue ::Integrations::Discord::UnauthorizedRequestError
          status :unauthorized
          { error: 'unauthorized request' }
        rescue ::Integrations::Discord::ResolverNotFoundError => e
          status :bad_request
          { error: e.message }
        end
      end
    end
  end
end
