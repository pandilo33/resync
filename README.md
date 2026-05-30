# Resync (Flutter)

Resync is a rapid intervention app for acute anxiety episodes with this flow:

1. Home screen with a large primary button.
2. Pre-session mood slider (1-10).
3. Random mini-game (Categorization, Pattern Sequence, Rhythm Tracer).
4. End Session at any time.
5. Post-session mood slider.
6. 30-day dashboard based on local storage.

## Requirement

- Flutter SDK 3.3+
- Dart SDK 3.3+

## Running the Project

1. Install the Flutter SDK and make sure `flutter --version` works.
2. From the project root, run:

```bash
flutter pub get
flutter run
```

To run the Android emulator and the Resync app with a single command on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\run-resync.ps1
```

If the platform folders (android/ios/web/windows/macOS/linux) do not exist yet, generate them first:

```bash
flutter create .
flutter pub get
flutter run
```

## Core Structure

- `lib/main.dart`
- `lib/src/app.dart`
- `lib/src/screens/home_screen.dart`
- `lib/src/screens/mood_calibration_screen.dart`
- `lib/src/screens/game_session_screen.dart`
- `lib/src/screens/dashboard_screen.dart`
- `lib/src/games/categorization_game.dart`
- `lib/src/games/pattern_sequence_game.dart`
- `lib/src/games/rhythm_tracer_game.dart`
- `lib/src/services/session_storage.dart`
- `lib/src/models/resync_session.dart`
