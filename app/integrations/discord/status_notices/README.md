# Status Notices

Status notices are messages sent to Discord channels to indicate the state of a Privy message.

## Overview

Status notices can be tought of as factories that produce DiscordEngine::Message instances which contain the content and components to be sent to Discord channels when a message's status changes. Each notice type (Available, Expired, etc.) builds a specific DiscordEngine::Message with the appropriate content and components to replace the original message in the channel.

These notices help maintain privacy by replacing sensitive content and provide clear feedback about the message's current state to users.

## Types of Notices

### Available Notice

- Used when a message needs to be hidden after its revelation time
- Replaces the original message content with a "Message Hidden" notice

### Created Notice

- Used when a message is created in Discord
- Replaces the original message with a "Message Created" notice

### CreationFailed Notice

- Used when a message fails to be created in Discord
- Replaces the original message with a "Creation Failed" notice

### Expired Notice

- Used when a message has been read and should be expired
- Replaces the original message with an "Expired" notice

### Found Notice

- Used when a message is found in Discord
- Replaces the original message with a "Message Found" notice

### NotFound Notice

- Used when a message is not found in Discord
- Replaces the original message with a "Message Not Found" notice

## Implementation

Status notices are implemented as separate classes that:

- Take a message object in their constructor
- Build the appropriate notice content
- Then you can use `update` or `create` to send the notice to Discord, depending on whether the message already exists in Discord.
