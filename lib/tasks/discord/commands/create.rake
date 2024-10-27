desc 'Executes listed tasks to create required commands, at :create namespace'
namespace :discord do
  namespace :commands do
    task create: :environment do
      tasks = [
        'discord:commands:create:connect',
        'discord:commands:create:say_hi'
      ]

      tasks.each do |task_name|
        Rake::Task[task_name].invoke
      rescue StandardError => e
        puts "Failed to execute #{task_name}: #{e.message}"
      end
    end
  end
end
