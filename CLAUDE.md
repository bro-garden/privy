# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Privy is a Ruby on Rails 7.2.2 application for creating temporary messages with expiration (time-based or visit-based). Messages are encrypted and can be created via Web UI, REST API (Grape), or Discord bot.

## Common Commands

### Development Server
```bash
rails s                          # Web server on port 3000
rake jobs:work                   # Delayed Job worker
rails tailwindcss:watch          # CSS watcher
foreman start -f Procfile.dev    # Run all processes
```

### Testing
```bash
bundle exec rspec                # Run all tests
bundle exec rspec spec/path      # Run specific spec file or directory
bundle exec guard                # Watch mode (auto-run on changes)
```

### Linting
```bash
bundle exec rubocop              # Ruby style (inherits from bg_cop gem)
bundle exec brakeman -z          # Security scanner
bundle exec bundle-audit check --update  # Gem vulnerability check
bundle exec mdl .                # Markdown linting
```

### Database
```bash
bundle exec rails db:create
bundle exec rails db:schema:load
bundle exec rails db:migrate
bundle exec rake data:create_internal_interfaces  # Seed initial interface data
```

## Architecture

### Multi-Interface Design
Messages can originate from multiple interfaces (Web, Discord, API). The `Interface` model represents each source. `ExternalMessage` links messages to external platforms.

### Key Patterns
- **Service Objects** (`app/services/`): Business logic lives in service classes (e.g., `Messages::Creator`, `Messages::Reader`, `Messages::Expirer`)
- **Wisper Pub/Sub** (`app/listeners/`): Services publish events, listeners subscribe to handle side effects (loose coupling)
- **Grape API** (`app/api/privy/`): REST API mounted at `/api`, separate from Rails controllers
- **Discord Engine** (`app/integrations/discord/`): Mountable engine at `/discord` with its own interactions, jobs, and status notices

### Request Flow
1. **Web**: `MessagesController` → `Messages::Creator` service → publishes events → listeners handle side effects
2. **API**: `Privy::Messages::Create` (Grape) → same service layer
3. **Discord**: Discord engine resolves interactions → `DiscordMessages::Creator` → message service layer

### Background Jobs
Delayed Job (database-backed) handles async work, primarily message expiration (`Messages::ExpireJob`).

### Encryption
Active Record encryption is enabled for message content. Keys are stored in Rails credentials (`config/credentials.yml.enc`).

### Models
- `Message` — core model with UUID identifier, expiration logic (time or visit count)
- `MessageVisit` — tracks each view of a message
- `Interface` — message source (web, discord, etc.)
- `ExternalMessage` / `DiscordMessage` — external platform references

## Tech Stack
Ruby 3.2.2, Rails 7.2.2, PostgreSQL, Grape, Hotwire (Turbo + Stimulus), Tailwind CSS, Delayed Job, Wisper, RbNaCl (libsodium)

## Environment Setup
Requires: PostgreSQL, libsodium (`brew install libsodium`), Ruby 3.2.2, Node.js 18.19.1. Rails master key needed for credentials — ask the team.
