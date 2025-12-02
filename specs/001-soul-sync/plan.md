# Implementation Plan: 이심전심 텔레파시 (Soul Sync)

**Branch**: `001-soul-sync` | **Date**: 2025-12-02 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-soul-sync/spec.md`

## Summary

Soul Sync is a two-player compatibility quiz where users answer O/X questions on a split-screen interface (each half rotated 180° for face-to-face play). After 5 questions, the app reveals how many answers matched and displays a playful compatibility result. The implementation adds a new screen (`SoulSyncScreen`) to the existing single-file Flutter architecture, reusing TDS design system, `TossButton`, `FadeInUp`, and haptic patterns.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: Flutter SDK only (no external packages per Constitution)
**Storage**: N/A (in-memory game state, hardcoded question list for MVP)
**Testing**: Manual testing only (Constitution: MVP Phase)
**Target Platform**: iOS 15+, Android API 21+
**Project Type**: Single-file Flutter app (`lib/main.dart`)
**Performance Goals**: 60fps minimum, instant haptic response on tap
**Constraints**: Must remain within single `main.dart` file; no new dependencies
**Scale/Scope**: 1 new screen, ~200-300 lines of code added to main.dart

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Simplicity First | ✅ PASS | Adding to existing main.dart, no new files, no abstractions |
| II. Performance Non-Negotiable | ✅ PASS | No game loop needed (turn-based Q&A), standard widget rendering |
| III. Design System Compliance (TDS) | ✅ PASS | Reusing TDS colors, TossButton, FadeInUp |
| IV. Physics Stability | ✅ N/A | No physics in Soul Sync (quiz-based, not movement-based) |
| V. Brand Voice Authenticity | ✅ PASS | Using 반말, playful phrases like "천생연분!", "꽤 맞네?" |

**UX & Brand Constraints:**
- ✅ Haptic patterns: `mediumImpact()` on O/X tap, `vibrate()` on high match
- ✅ SafeArea and MediaQuery for split-screen layout
- ⚠️ Must test two-person face-to-face gameplay on physical device

**Development Workflow:**
- ✅ Single file architecture maintained
- ✅ No tests required (MVP phase)
- ✅ Manual testing acceptable

## Project Structure

### Documentation (this feature)

```text
specs/001-soul-sync/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # N/A (no API - local only)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
└── main.dart            # Single file containing all code
    ├── TDS              # Design system (existing)
    ├── ThumbSomeApp     # Main app (existing)
    ├── IntroScreen      # Lobby - add Soul Sync button (modify)
    ├── GameScreen       # Sticky Fingers game (existing)
    ├── SoulSyncScreen   # NEW: Soul Sync quiz game
    ├── GamePainter      # Sticky Fingers painter (existing)
    ├── TossButton       # Reusable button (existing)
    └── FadeInUp         # Animation widget (existing)
```

**Structure Decision**: Single-file Flutter architecture per Constitution Principle I. All new code goes into `main.dart`. No new files created.

## Complexity Tracking

> No violations. Implementation follows all Constitution principles.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| (none) | — | — |
