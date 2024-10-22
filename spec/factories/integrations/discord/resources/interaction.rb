FactoryBot.define do
  factory :interaction, class: 'Discord::Resources::Interaction' do
    type { [1, 2, 3].sample }

    skip_create
    initialize_with { new(**attributes) }
  end
end
