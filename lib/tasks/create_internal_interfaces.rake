desc 'API Routes'
task create_internal_interfaces: :environment do
  Interface.create(source: :web)
  Interface.create(source: :api)

  puts 'Done!'
rescue ActiveRecord::RecordInvalid => e
  puts "error: #{e.message}"
end
