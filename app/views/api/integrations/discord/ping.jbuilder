return unless @resolver.response_status == Discord::Interactions::Resolvers::Ping::RESPONSE_STATUS[:OK]

json.type @resolver.body.type
