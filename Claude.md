# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Project Name:** 썸썸 (Thumb Some) - "게임인 척하며 자연스럽게 손잡기"
**Type:** Flutter Mobile App (iOS & Android)
**Status:** MVP Complete (v2.0.0), Phase 2 in progress

A hyper-casual social interactive app that creates natural physical contact between two people through touch-based mini-games on a shared smartphone screen.

### Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x (Dart 3.3.0+) |
| State | Local state (Riverpod planned) |
| Graphics | CustomPainter for game rendering |
| Audio | audioplayers ^6.5.1 |
| Animations | flutter_animate, shimmer, animate_gradient |
| Persistence | shared_preferences |
| IAP | in_app_purchase ^3.2.0 |

---

## Commands

```bash
# Development
flutter pub get              # Install dependencies
flutter run                  # Run debug build
flutter run --release        # Run release build

# Code Quality
flutter analyze              # Static analysis
dart format .               # Format code (80 char line limit)

# Testing
flutter test                 # Run all tests
flutter test --coverage      # Generate coverage report

# Building
flutter build apk --release  # Android APK
flutter build appbundle      # Play Store AAB
flutter build ios --release  # iOS release

# Asset Generation
flutter pub run flutter_launcher_icons:main   # Generate app icons
flutter pub run flutter_native_splash:create  # Generate splash screen

# Git Hooks Setup (run after cloning)
./scripts/setup-hooks.sh
```

---

## Architecture

### Project Structure

```
lib/
├── main.dart                    # Entry point, SettingsService init
├── app/
│   └── app.dart                # ThumbSomeApp widget + routing
├── core/                       # Shared services and utilities
│   ├── deep_links/             # Deep link handling
│   ├── haptics/                # Haptic feedback (HapticFeedback.*)
│   ├── packs/                  # Content pack system
│   ├── premium/                # IAP service
│   ├── settings/               # SharedPreferences wrapper
│   ├── share/                  # Share functionality
│   └── sound/                  # Audio playback
├── design_system/              # TDS + Material Design 3
│   ├── tds.dart               # Colors, typography, motion
│   ├── components/            # GlassButton, GlowCard, etc.
│   └── motion/                # FadeInUp animations
└── features/                   # Feature modules
    ├── intro/                  # Main menu
    ├── sticky_fingers/         # Game Mode A (쫀드기 챌린지)
    ├── soul_sync/              # Game Mode B (이심전심)
    ├── penalty_roulette/       # Game Mode C (복불복)
    ├── couple_mode/            # Phase 2 feature
    ├── settings/               # Settings screen
    └── tutorial/               # Tutorial flow
```

### Design System (TDS)

Location: `lib/design_system/tds.dart`

- **Seed Color:** Neon Pink `#FF0099`
- **Theme:** Dark mode only (`Brightness.dark`)
- **Color Generation:** `ColorScheme.fromSeed()` for M3 tonal palette
- **Motion:**
  - Standard UI: M3 easing (`Easing.emphasizedDecelerate`)
  - Game feedback: `Curves.elasticOut` (bouncy feel)

### Game Modes

| Mode | File | Mechanic |
|------|------|----------|
| Sticky Fingers | `features/sticky_fingers/` | Two players touch characters for 15s, paths cross to induce contact |
| Soul Sync | `features/soul_sync/` | Split-screen 50/50 O/X compatibility test |
| Penalty Roulette | `features/penalty_roulette/` | Custom penalty wheel |

### Haptic Feedback Patterns

```dart
// Game start
HapticFeedback.heavyImpact();

// Progress feedback
HapticFeedback.lightImpact();

// Success
HapticFeedback.vibrate();

// Failure
HapticFeedback.heavyImpact(); // double
```

---

## Key Files

| Purpose | Location |
|---------|----------|
| App entry | `lib/main.dart` |
| Routing | `lib/app/app.dart` |
| Design tokens | `lib/design_system/tds.dart` |
| Game logic (Mode A) | `lib/features/sticky_fingers/sticky_fingers_screen.dart` |
| Settings service | `lib/core/settings/settings_service.dart` |
| Sound service | `lib/core/sound/sound_service.dart` |

---

## Development Patterns

### CustomPainter for Games

Game screens use `CustomPainter` with `Ticker` for 60fps rendering:

```dart
class GamePainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    // Optimize: only repaint when necessary
    return oldDelegate.someValue != someValue;
  }
}
```

### Animation Pattern (8-figure path)

```dart
// Sin/Cos combination for crossing paths
targetA = Offset(
  centerX - 80 + sin(_time * 1.5) * 60 * intensity,
  centerY + cos(_time * 2.1) * 100 * intensity,
);

targetB = Offset(
  centerX + 80 + cos(_time * 1.8) * 60 * intensity,  // Opposite phase
  centerY + sin(_time * 2.4) * 100 * intensity,
);
```

### Service Initialization

Services are initialized in `main()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService().init();
  runApp(const ThumbSomeApp());
}
```

---

## CI/CD

### GitHub Actions (.github/workflows/)

- **ci.yml:** analyze, test, build-android, build-ios, security-scan
- **release.yml:** Production release with version tagging

### Pre-commit Hook

Automatically runs `dart format` before commits. Install with:
```bash
./scripts/setup-hooks.sh
```

---

## Conventions

### Dart Formatting
- Line length: 80 characters
- Format on save enabled (VS Code)
- Run `dart format .` before committing

### Naming
| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `sticky_fingers_screen.dart` |
| Classes | PascalCase | `StickyFingersScreen` |
| Variables | camelCase | `gameProgress` |
| Constants | camelCase | `kSpringCurve` |

### Git Commits
Use Conventional Commits format (no AI attribution):
```
feat(soul-sync): add compatibility percentage calculation
fix(haptics): correct vibration timing on iOS
chore(deps): update flutter_animate to 4.6.0
```

### Linting Rules (analysis_options.yaml)
- `prefer_const_constructors`: true
- `prefer_single_quotes`: true
- `avoid_print`: true
- `sort_pub_dependencies`: true

---

## Deep Links

| Route | Purpose |
|-------|---------|
| `thumbsome://` | Home |
| `thumbsome://game/sticky-fingers` | Sticky Fingers mode |
| `thumbsome://game/soul-sync` | Soul Sync mode |
| `thumbsome://penalty` | Penalty Roulette |

---

## Assets

```
assets/
├── branding/
│   ├── icon.png        # App icon source
│   └── splash.png      # Splash screen
└── sounds/             # Game audio effects
```

---

## Known Technical Debt

1. Target position uses hardcoded screen values - needs responsive calculation
2. Test coverage is minimal (single smoke test)
3. Small device testing incomplete (iPhone SE, Galaxy A series)
4. Android VIBRATE permission needs verification

---

## Quick Reference

### Run on specific device
```bash
flutter devices                    # List devices
flutter run -d <device_id>         # Run on specific device
flutter run -d chrome              # Web (debug only)
```

### Debug specific issue
```bash
flutter run -v                     # Verbose output
flutter logs                       # Show device logs
```

### Clean build
```bash
flutter clean && flutter pub get && flutter run
```

### Run single test file
```bash
flutter test test/widget_test.dart
```

---

## Related Issues

Active development tracked in GitHub Issues:
- #14: Dynamic target position
- #17: Test coverage expansion
- #18: Riverpod migration
- #19: Firebase integration
