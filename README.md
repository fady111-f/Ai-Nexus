# MockMate

> Your toughest interview before the real one.

## Overview

MockMate is a real-time AI interview coaching application being developed for
the CU AI Nexus competition. Its product vision includes:

- personalized interview preparation;
- CV-aware and target-job-based interview experiences;
- real-time voice conversations;
- English, Arabic, and Tech-Arabish support;
- actionable interview feedback;
- long-term progress tracking.

The core application foundation is implemented, while the live interview and
AI capabilities are still under development.

## Current Implemented Features

- Premium Sign In experience
- Temporary local authentication and Continue as Guest
- Four-step onboarding
- Career profile and target-role configuration
- Interview language and difficulty preferences
- Local persistence with SharedPreferences
- Personalized Home Dashboard
- Truthful empty states and an Interview DNA preview
- Start Interview placeholder interaction

Firebase authentication, live voice interviews, and AI feedback are not
implemented yet.

## Current App Flow

New users:

```text
Sign In → Onboarding → Personalized Home Dashboard
```

Returning users with a completed local profile:

```text
Sign In → Home
```

## Tech Stack

- Flutter
- Dart
- SharedPreferences for the current local profile
- Feature-first structure with domain service/repository abstractions
- Constructor injection from the application composition root

## Project Structure

```text
lib/
├── core/                   # Routing, theme, and shared app primitives
├── features/
│   ├── auth/               # Temporary authentication and Sign In UI
│   ├── onboarding/         # Profile model, persistence, and four-step flow
│   └── home/               # Personalized dashboard and empty states
└── main.dart               # App composition and dependency wiring
test/                       # Unit and widget tests by feature
```

Platform projects are available under `android/`, `ios/`, `web/`, and
`windows/`.

## Getting Started

### Requirements

- Flutter SDK compatible with the version constraints in `pubspec.yaml`
- Dart (included with Flutter)
- Android Studio or Visual Studio Code with Flutter support
- An Android device or emulator

### Run locally

```bash
flutter pub get
flutter run
```

## Validation

Run the same baseline checks before opening a pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

The team should build APKs locally; generated build output is not committed.

## Development Status

**Implemented:** Sign In, temporary local authentication, onboarding, local
profile persistence, and the personalized Home Dashboard.

**Planned:** Interview Setup, live voice interviews, AI integration, session
history, completed Interview DNA, analytics, and Firebase authentication.

## Team Workflow

1. Pull the latest `main`.
2. Create a focused feature or fix branch.
3. Make a small, coherent change.
4. Run formatting, analysis, and tests.
5. Push the branch.
6. Open a Pull Request.
7. Merge after review and passing validation.

Suggested branch names include:

- `feature/interview-setup`
- `feature/live-interview`
- `feature/ai-integration`
- `fix/onboarding-landscape`

See [CONTRIBUTING.md](CONTRIBUTING.md) for the lightweight collaboration rules.

## Important

- Firebase is not connected yet.
- Authentication is currently temporary and local.
- Never commit API keys, `.env` files, signing keys, tokens, or credentials.
- Keep AI, authentication, and platform integrations behind clean interfaces.
