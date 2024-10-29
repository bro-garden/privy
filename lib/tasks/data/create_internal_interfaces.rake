desc 'Creates internal Interfaces'

namespace :data do
  task create_internal_interfaces: :environment do
    Interface::INTERNAL_SOURCES.each { |source| Interface.create(source:) }

    puts 'Done!'
  rescue ActiveRecord::RecordInvalid => e
    puts "error: #{e.message}"
  end
end
