# Contributing to MockMate

Keep changes focused, reviewable, and safe for the rest of the team.

## Workflow

1. Pull the latest `main` and create a feature or fix branch from it.
2. Use a descriptive branch name such as `feature/interview-setup` or
   `fix/onboarding-landscape`.
3. Make focused changes and use meaningful commit messages.
4. Run the required validation before pushing:

   ```bash
   dart format --output=none --set-exit-if-changed lib test
   flutter analyze
   flutter test
   ```

5. Push the branch and open a Pull Request.
6. Merge only after review and successful validation.

After this initial repository setup, do not push feature work directly to
`main`.

## Repository Safety

- Never commit API keys, tokens, `.env` files, signing keys, keystores, or
  service-account credentials.
- Do not commit generated build output, APKs, local IDE state, or device audit
  artifacts.
- Keep `pubspec.lock` committed because MockMate is an application.
- Do not mix unrelated refactors or formatting changes into a feature commit.
- Keep external integrations behind the existing service and repository
  boundaries where possible.
