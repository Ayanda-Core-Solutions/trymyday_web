# TryMyDay Web Agent Guide

## Repository scope

This repository owns the public TryMyDay Flutter web experience and its
web-specific Firebase Functions:

- `lib/`: Flutter web application code.
- `test/`: Flutter unit and widget tests.
- `web/`: web entrypoint, metadata, icons, and well-known resources.
- `functions/`: isolated web functions, including contact and account-deletion
  entrypoints.
- `env/`: committed environment examples; real values remain local-only.

Related repositories are:

- `Ayanda-Core-Solutions/trymyday`: mobile application and primary Firebase
  backend.
- `Ayanda-Core-Solutions/trymyday-documentation`: canonical product,
  architecture, environment, Firestore, and release documentation.

Keep changes inside this repository unless the task explicitly includes a
related repository. Describe required follow-up changes instead of assuming
write access elsewhere.

## Working conventions

- Preserve the existing Flutter structure and reuse established components,
  styling, and responsive patterns.
- Maintain compatibility with the mobile app's public links, authentication
  expectations, Firebase data contracts, and account-deletion flow.
- Keep web Cloud Functions isolated in the Firebase `web` codebase.
- Never commit `env/dev.json`, `env/prod.json`, Functions `.env` files,
  credentials, tokens, or secrets. Use committed examples and Firebase secrets.
- Preserve existing user changes and avoid broad mechanical rewrites.
- Do not deploy the site or Cloud Functions unless explicitly requested.
  Production deployment always requires deliberate confirmation.

## Validation

Run checks in proportion to the change. The normal Flutter checks are:

```bash
dart format <changed-dart-files>
flutter analyze
flutter test
```

Build the production web target when routing, assets, environment handling, or
release behavior changes:

```bash
flutter build web --dart-define-from-file=env/prod.json
```

For changes under `functions/`, install dependencies if needed and exercise the
relevant emulator or function flow. The web functions deploy command is:

```bash
firebase deploy --only functions:web:sendWebContactEmail,functions:web:requestWebAccountDeletion
```

The command is documentation, not standing authorization to deploy.

## Cross-repository coordination

When a change alters a public link, Firebase environment, Firestore shape,
authentication flow, account-deletion behavior, or shared user journey:

1. Identify the matching impact in `trymyday`.
2. Identify the exact documentation that must change in
   `trymyday-documentation`.
3. Keep public contracts backward-compatible until affected repositories can be
   released safely.
4. Record lasting architecture decisions as an ADR in the documentation
   repository.

## Done means

A task is complete when responsive behavior works, relevant tests and static
checks pass, production web compilation is checked when applicable, no secrets
or unrelated changes are included, and cross-repository follow-ups are clear.
