FactoryBot.define do
  factory :guild, class: 'Discord::Resources::Guild' do
    id { Faker::Number.unique.number(digits: 18).to_s }

    skip_create
    initialize_with { new(**attributes) }
  end
end
