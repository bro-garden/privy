FactoryBot.define do
  factory :application, class: 'Discord::Resources::Application' do
    id { Faker::Number.unique.number(digits: 18).to_s }

    skip_create
    initialize_with { new(**attributes) }
  end
end
