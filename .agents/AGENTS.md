# MockMate — Agent Directives

## Architecture

- Preserve the feature-first architecture (`lib/features/<feature>/{domain,data,presentation}`).
- Separate directives, orchestration, and execution concerns across layers.
- Use constructor-based dependency injection; no service locators or global singletons.
- Keep Firebase and AI behind replaceable interface abstractions.
- Use Flutter's built-in named routing (`onGenerateRoute`).
- Do not introduce Bloc, Riverpod, Provider, GetX, Redux, or any state-management package.

## Code Quality

- Use tool-first verification: `flutter analyze`, `flutter test`, `dart format`.
- Avoid destructive edits to unrelated features.
- Never alter Sign In, Onboarding, or Home behavior without explicit approval.
- Keep temporary files inside `.tmp/` at project root.
- Never commit secrets; keep `.env` and credentials untracked.
- Validate before completion: all builds and tests must pass.

## Data & Persistence

- Isolate all storage behind repository abstractions.
- Do not read SharedPreferences directly in UI widgets.
- Use versioned DTOs with stable enum serialization (explicit string maps, not `enum.name`).
- Handle missing data, malformed JSON, and wrong preference types safely.
- Never crash from corrupted local storage.
- Use separate, namespaced SharedPreferences keys per feature.
- Do not clear onboarding data when clearing interview data.

## Truthfulness

- Never fabricate user data, streaks, readiness percentages, or hiring predictions.
- Empty states must be honest — show "0" or "—", not invented values.
- Demo data must be explicit (`isDemo = true`), labeled, and only available in debug mode.

## Documentation

- Update this file when implementation decisions change the architectural approach.
- Preserve all existing comments and docstrings unrelated to current changes.
