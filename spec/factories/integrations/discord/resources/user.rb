FactoryBot.define do
  factory :user, class: 'Discord::Resources::User' do
    id { Faker::Number.unique.number(digits: 20).to_s }
    global_name { Faker::Internet.username }
    username { Faker::Internet.username }

    skip_create
    initialize_with { new(**attributes) }
  end
end
