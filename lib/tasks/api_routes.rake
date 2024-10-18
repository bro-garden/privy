desc 'API Routes'
task api_routes: :environment do
  Privy::API.routes.each do |api|
    method = api.request_method.ljust(10)
    path = api.path

    puts "#{method} #{path}"
  end
end
