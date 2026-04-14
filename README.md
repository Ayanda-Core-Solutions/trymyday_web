# trymyday_web

TryMyDay web app.

## Run locally

For normal local development in VS Code, you can still use:

- `TryMyDay Web (Chrome)`
- `TryMyDay Web (Chrome Release)`

If Chrome shows the `--no-sandbox` warning banner when launched by Flutter, use a local static-serve flow instead:

1. Run the VS Code task `Build Web`
2. Run the VS Code task `Serve build/web`
3. Open `http://localhost:8080` in your normal browser

There is also a combined task:

- `Build and Serve Web`

This avoids Flutter launching its managed Chrome instance.
