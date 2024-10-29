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

### Listing all existing commands

We can list all existing commands with:

```bash
bundle exec rake discord_engine:commands:list
```

### deleting a command

Knowing the id of a command(`command_id`), we can delete it by running:

```bash
bundle exec rake discord_engine:commands:delete'[command_id]'
```

### creating privy required commands

We need to create once, commands into Discord Bot.
If the command we are creating already exists (by name), the task will fail
If we updated the command, we should delete it, and then create it again

This creates all commands:

```bash
bundle exec rake discord_engine:commands:create
```

This creates `/connect` command:

```bash
bundle exec rake discord:commands:create:connect
```

This creates `/say_hi` command:

```bash
bundle exec rake discord:commands:create:say_hi
```
