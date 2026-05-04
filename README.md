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

## Environment files

Real environment files are local-only and are ignored by Git. Keep the real
values somewhere private, such as Google Drive, and copy them into the project
when you need to run or build the app.

Flutter client values use JSON because Flutter supports
`--dart-define-from-file` with JSON files. Create these local files from the
committed examples:

- `env/dev.example.json`
- `env/prod.example.json`

The local files should be:

- `env/dev.json`
- `env/prod.json`

Use them with:

```sh
flutter run -d chrome --dart-define-from-file=env/dev.json
flutter build web --dart-define-from-file=env/prod.json
```

Cloud Functions runtime values use `.env` files. Create these local files from
the committed examples:

- `functions/.env.dev.example`
- `functions/.env.prod.example`

The local files should be:

- `functions/.env.dev`
- `functions/.env.prod`

For local emulator work, copy the matching functions env file to
`functions/.env`. Keep SMTP credentials in Firebase secrets, not env files:

```sh
firebase functions:secrets:set SMTP_USER
firebase functions:secrets:set SMTP_PASS
```
