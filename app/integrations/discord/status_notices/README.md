# Status Notices

Status notices are messages sent to Discord channels to indicate the state of a Privy message.

## Overview

Status notices are DiscordEngine::Message instances that contain the content and components to be sent to Discord channels when a message's status changes. Each notice type (Available, Expired, etc.) builds a specific DiscordEngine::Message with the appropriate content and components to replace the original message in the channel.

These notices help maintain privacy by replacing sensitive content and provide clear feedback about the message's current state to users.

## Types of Notices

### Available Notice
- Used when a message needs to be hidden after its revelation time
- Replaces the original message content with a "Message Hidden" notice

### Expired Notice
- Used when a message has been read and should be expired
- Replaces the original message with an "Expired" notice

## Implementation

Status notices are implemented as separate classes that:
1. Take a message object in their constructor
2. Build the appropriate notice content
3. Then you can use `update` or `create` to send the notice to Discord, depending on whether the message already exists in Discord.
