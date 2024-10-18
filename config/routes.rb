Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  mount Privy::API => '/api'
  root 'messages#new'

  resources :messages, only: %i[show new create]
end
