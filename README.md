# privy

**Temp Messages** is a web application built with [**Ruby on Rails 7**](https://guides.rubyonrails.org/) and [**Turbo**](https://turbo.hotwired.dev/), dedicated to creating and sharing temporary messages to which an expiration date or a visit limit can be assigned.

- [privy](#privy)
  - [Getting Started](#getting-started)
    - [Installation Prerequisites](#installation-prerequisites)
    - [Setup](#setup)
  - [Tests](#tests)
  - [Running the application locally](#running-the-application-locally)
  - [Technical Docs Reference](#technical-docs-reference)
    - [Dev Guides \& Tooling](#dev-guides--tooling)

## Getting Started

### Installation Prerequisites

**Ruby 3.2.2**: Use `rbenv` to install and manage the Ruby version:

```bash
rbenv install 3.2.2
```

Install Homebrew if you don't have it yet:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

PostgreSQL: If you're on a Mac with Apple Silicon, install PostgreSQL by following these steps:

```bash
brew install postgresql
```

Start PostgreSQL:

```bash
brew services start postgresql
```

Verify that PostgreSQL is running:

```bash
psql postgres
```

This Project uses the rbnacl gem, which a Ruby wrapper for the libsodium library. Libsodium is a popular cryptographic library that provides a wide range of cryptographic primitives. You can install Libsodium using homebrew:

```bash
brew install libsodium
```

### Setup

Clone this repository and navigate to the project directory:

```bash
git clone git@github.com:bro-garden/privy.git
cd privy
```

Install the dependencies:

```bash
bundle install

npm install -g yarn
yarn install
```

Ask for Rails credentials keys.

**Database**
Create the database and load the schema:

```bash
bundle exec rails db:create
bundle exec rails db:schema:load
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

**to run the web version and/or make changes on it:** In a separate terminal tab, run the TailwindCSS watcher for real-time style compilation:

```bash
rails tailwindcss:watch
```

**to try Discord integration** you need to connect Discord, you can follow [Integrations](./app/integrations/README.md#connect-to-your-local-deploy)

## Technical Docs Reference

### Dev Guides & Tooling

- [Integrations](./app/integrations/README.md)
- [Rake Tasks](./lib/tasks/README.md)
