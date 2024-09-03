FactoryBot.define do
  factory :message do
    content { 'Hello, World!' }
    expiration_limit { 1 }
    expiration_type { 'hours' }
  end
end
