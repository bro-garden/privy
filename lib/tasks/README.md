# Rake Tasks

- [Rake Tasks](#rake-tasks)
  - [Listing API Endpoints](#listing-api-endpoints)
  - [Create internal interfaces](#create-internal-interfaces)
  - [Discord Commands Operations](#discord-commands-operations)

## Listing API Endpoints

Grape is somewhat unique; if you run `rails routes`, it won’t show the Grape API routes. You can use a rake task to list them:

```bash
bundle exec rake api_routes
```

## Create internal interfaces

You need to initially set up internal Interfaces, so you need to run:

```bash
bundle exec rake data:create_internal_interfaces
```

## Discord Commands Operations

A group of tasks created for interacting with discord commands cration, indexing and deleting:

See the [engine's README](https://github.com/bro-garden/discord-engine/blob/main/lib/tasks/README.md) for more information on how to create a new command, and how to list and delete existing commands.

This creates `/connect` command:

```bash
bundle exec rake discord:commands:create:connect
```

This creates `/say_hi` command:

```bash
bundle exec rake discord:commands:create:say_hi
```

This creates `/message` command:

```bash
bundle exec rake discord:commands:create:message
```
