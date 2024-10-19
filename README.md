# privy
**Temp Messages** is a web application built with [**Ruby on Rails 7**](https://guides.rubyonrails.org/) and [**Turbo**](https://turbo.hotwired.dev/), dedicated to creating and sharing temporary messages to which an expiration date or a visit limit can be assigned.

## Prerequisites
**Ruby 3.1.2**: Use `rbenv` to install and manage the Ruby version:

```bash
rbenv install 3.1.2
rbenv local 3.1.2
```

PostgreSQL: If you're on a Mac with Apple Silicon, install PostgreSQL by following these steps:

Install Homebrew if you don't have it yet:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install PostgreSQL:
```bash
brew install postgresql
```

Start PostgreSQL:
```bash
brew services start postgresql
Verifica que PostgreSQL esté funcionando:
```

Verify that PostgreSQL is running:
```bash
psql postgres
```

## Setup
Clone this repository and navigate to the project directory:
```bash
git clone git@github.com:bro-garden/privy.git
cd privy
```

Install the dependencies:
```bash
bundle install
yarn install
```

This Project uses teh rbnacl gem, and requires libsodium on mac:
```bash
brew install libsodium
```

Set up environment variables: This project uses dotenv-rails. Rename the .env.example file to .env and ensure to fill in the necessary variables. Remember to run the following command to initialize the database encryption, and then add the resulting values to your .env file:
```bash
rails db:encryption:init
```

## Database
Create the database and load the schema:
```bash
bundle exec rails db:create
bundle exec rails db:schema:load
```

## Styles
This project uses TailwindCSS for styling. To compile styles in real time, run:
```bash
bin/rails tailwindcss:watch
```

## Tests
The project is configured with RSpec to run tests. It also uses Shoulda Matchers to facilitate unit testing.

To run the test suite, use one of the following commands:

Run all tests:
```bash
bundle exec rspec
```

Run the test watcher to automatically run unit tests when changes are detected:
```bash
bundle exec guard
```

## Running the application locally
To start the application in your local environment, follow these steps:

Start the Rails development server:
```bash
rails s
```

In a separate terminal tab, run the TailwindCSS watcher for real-time style compilation:
```bash
rails tailwindcss:watch
```

To test Discord interactions, you will need to expose your local server using a tool like Ngrok. If you're using Ngrok, run this command (assuming your app runs on port 3000):
```bash
ngrok http 3000
```

Then, paste the HTTPS link into the application's Discord dashboard. You should see two requests pointing to `/api/discord/interactions`: one with a `200` status code response and another with a `401`
<img width="979" alt="image" src="https://github.com/user-attachments/assets/de7df0f3-478b-4507-8722-b9550820caa2">


### listing api endpoints
Grape is somewhat unique; if you run rails routes, it won’t show the Grape API routes. You can use a rake task to list them:
```bash
bundle exec rake api_routes
```
<img width="441" alt="image" src="https://github.com/user-attachments/assets/8de3688e-ebca-45ea-82fb-815a3410525d">

