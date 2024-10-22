# Integrations

- [Integrations](#integrations)
  - [Connect To Your Local Deploy](#connect-to-your-local-deploy)

## Discord

### Connect To Your Local Deploy

To connect Discord, you will need to expose your local server using a tool like Ngrok. If you're using Ngrok, run this command (assuming your app runs on port 3000):
```bash
ngrok http 3000
```

Then, paste the HTTPS link into the application's Discord dashboard. You should see two requests pointing to `/api/discord/interactions`: one with a `200` status code response and another with a `401`
<img width="979" alt="image" src="https://github.com/user-attachments/assets/de7df0f3-478b-4507-8722-b9550820caa2">