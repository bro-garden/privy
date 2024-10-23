# Rake Tasks

- [Rake Tasks](#rake-tasks)
  - [Listing API Endpoints](#listing-api-endpoints)

## Listing API Endpoints

Grape is somewhat unique; if you run `rails routes`, it won’t show the Grape API routes. You can use a rake task to list them:

```bash
bundle exec rake api_routes
```
