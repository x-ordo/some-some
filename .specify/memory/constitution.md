<!--
SYNC IMPACT REPORT
==================
Version change: 0.0.0 → 1.0.0 (Initial ratification)
Modified principles: N/A (new constitution)
Added sections:
  - Core Principles (5 principles)
  - UX & Brand Constraints
  - Development Workflow
  - Governance
Removed sections: N/A
Templates requiring updates:
  - .specify/templates/plan-template.md ✅ (compatible - constitution gates generic)
  - .specify/templates/spec-template.md ✅ (compatible - user story structure intact)
  - .specify/templates/tasks-template.md ✅ (compatible - task phases align)
  - .specify/templates/checklist-template.md ✅ (compatible - no conflicts)
  - .specify/templates/agent-file-template.md ✅ (compatible - no conflicts)
Follow-up TODOs: None
-->

# 썸썸 (Thumb Some) Constitution

## Core Principles

### I. Simplicity First

Every feature starts as the simplest possible implementation. The current single-file MVP architecture (`main.dart`) is intentional and MUST NOT be split into modules until adding Mode B (이심전심 텔레파시) or Mode C (복불복 룰렛) explicitly requires it.

**Rules:**
- MUST prefer editing existing code over creating new files
- MUST NOT add abstractions, helpers, or utilities for one-time operations
- MUST NOT design for hypothetical future requirements (YAGNI)
- MUST NOT add external dependencies unless absolutely necessary—prefer built-in Flutter APIs

**Rationale:** Complexity is the enemy of rapid iteration. Premature abstraction creates maintenance burden without immediate value.

### II. Performance Non-Negotiable

The game MUST maintain 60fps minimum (120fps on ProMotion displays). This is not a nice-to-have—it directly affects the "쫀득한" (chewy) feel that defines the user experience.

**Rules:**
- MUST use `Ticker` directly for game loops, not `AnimationController`
- MUST profile performance before AND after any game loop changes
- MUST test on physical devices, not simulators (especially for haptics)
- `CustomPainter.shouldRepaint` returns `true` intentionally—do not "optimize" this

**Rationale:** Frame drops destroy the tactile illusion. Users will feel the difference even if they can't articulate it.

### III. Design System Compliance (TDS)

All UI MUST follow the Toss Design System (TDS) with kitsch accents. Deviating from the color palette requires explicit approval.

**Color Palette (immutable):**
- `background: #17171C` (Dark mode base)
- `primaryBlue: #0064FF` (Toss brand color)
- `kitschPink: #FF007F` (Game accent)
- `kitschYellow: #FFD700` (Secondary accent)

**Typography:** `-0.5` letter spacing always
**Motion:** `Curves.elasticOut` for spring animations

**Rationale:** Visual consistency builds trust. The kitsch overlay signals "this is playful" without undermining the solid UX foundation.

### IV. Physics Stability

Game physics constants have been carefully playtested and balanced. Changes require explicit user request AND playtesting on a physical device.

**Protected Constants:**
- `gameDuration: 15.0` seconds
- `targetRadius: 45.0`
- `touchTolerance: 60.0`
- `intensity: 1.0 + (progress * 2.0)`

**Rules:**
- MUST NOT change physics values without playtesting
- MUST NOT alter the sin/cos movement algorithm without explicit request
- MUST document difficulty changes with before/after comparison

**Rationale:** Game feel is fragile. Small changes compound into dramatically different experiences.

### V. Brand Voice Authenticity

The B-grade, kitsch aesthetic is a feature, not a bug. All user-facing copy MUST maintain casual Korean slang and intentional cheesiness.

**Rules:**
- MUST use 반말 (casual speech), NEVER 존댓말 (formal speech)
- MUST prefer playful phrases: "띠로리~", "천생연분!", "어머! 닿겠어!"
- MUST NOT use corporate/formal language: "축하드립니다", "완료하셨습니다"
- Korean OK in code comments for domain-specific terms

**Rationale:** The target users (20-30대 in 썸 situations) respond to relatable, slightly embarrassing energy. Over-professionalism kills the vibe.

## UX & Brand Constraints

**Device Testing Mandate:**
- Haptic feedback (`HapticFeedback.*`) MUST be tested on physical devices
- Multi-touch interactions MUST be tested with actual two-person gameplay
- Screen size edge cases MUST be validated on iPhone SE (small) and iPad (large)

**Safe Area & Screen Handling:**
- All screens MUST use `SafeArea` widget
- Target positions MUST use `MediaQuery.of(context).size`, not hard-coded offsets
- Known debt: initial target positions are hard-coded (acceptable for MVP, fix before Mode B)

**Haptic Patterns:**
- `lightImpact()` → subtle feedback (heartbeat pulse)
- `mediumImpact()` → standard feedback (button tap)
- `heavyImpact()` → strong feedback (game start/fail)
- `vibrate()` → celebration (success state only)

## Development Workflow

**Git & Commits:**
- Branch naming: `claude/feature-name-{sessionId}`
- Commit messages: `feat:`, `fix:`, `refactor:` prefixes
- MUST commit only working (playable) code
- MUST NOT commit code that hasn't been verified on device for haptic/multi-touch features

**Code Style:**
- `dart format` before all commits
- Line length: 120 characters
- Private variables: `_camelCase`
- Constants: `camelCase` (not SCREAMING_SNAKE)
- Comments: Korean OK for domain terms, English for technical concepts

**Testing Strategy (MVP Phase):**
- Manual testing is acceptable and sufficient
- Unit/widget tests MUST NOT be added unless bugs appear in production
- Test additions require explicit user request

**Refactoring Policy:**
- MUST ask before splitting `main.dart`
- MUST NOT refactor during feature implementation unless explicitly requested
- Complexity additions MUST be justified in the plan document

## Governance

This constitution supersedes all other development practices for this project. All PRs, code reviews, and implementation decisions MUST verify compliance with these principles.

**Amendment Procedure:**
1. Propose change with rationale
2. Document impact on existing code
3. Update constitution version
4. Update dependent templates if affected

**Versioning Policy:**
- MAJOR: Principle removal or backward-incompatible redefinition
- MINOR: New principle or materially expanded guidance
- PATCH: Clarifications, wording, non-semantic refinements

**Compliance Review:**
- Every feature plan MUST include a Constitution Check section
- Violations MUST be explicitly justified in the Complexity Tracking table
- Runtime guidance in `CLAUDE.md` remains the primary development reference

**Version**: 1.0.0 | **Ratified**: 2025-12-02 | **Last Amended**: 2025-12-02
