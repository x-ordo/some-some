# Tasks: 이심전심 텔레파시 (Soul Sync)

**Input**: Design documents from `/specs/001-soul-sync/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Not requested (Constitution: Manual testing only for MVP phase)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single-file Flutter**: All code in `lib/main.dart`
- No separate model/service files per Constitution Principle I (Simplicity First)

---

## Phase 1: Setup (Navigation Entry Point)

**Purpose**: Add Soul Sync button to IntroScreen for navigation

- [x] T001 Add "이심전심 텔레파시" button to IntroScreen in lib/main.dart
- [x] T002 Add placeholder SoulSyncScreen widget class in lib/main.dart
- [x] T003 Add navigation from IntroScreen to SoulSyncScreen in lib/main.dart

**Checkpoint**: App runs, Soul Sync button visible, tapping navigates to empty screen

---

## Phase 2: Foundational (Shared Data & Components)

**Purpose**: Question data and reusable UI components needed by all user stories

- [x] T004 Add hardcoded question list constant (_soulSyncQuestions) in lib/main.dart
- [x] T005 [P] Create _buildOXButton helper method for O/X circular buttons in lib/main.dart
- [x] T006 [P] Create _PlayerArea widget for single player's half of split screen in lib/main.dart

**Checkpoint**: Question data available, O/X button and PlayerArea components ready for use

---

## Phase 3: User Story 1 - 기본 궁합 테스트 플레이 (Priority: P1) 🎯 MVP

**Goal**: Two players answer 5 O/X questions on split-screen, see match result

**Independent Test**: Two people can complete 5 questions and see "X개 일치" result

### Implementation for User Story 1

- [x] T007 [US1] Add SoulSyncScreen state variables (_questions, _currentIndex, _currentAnswers, _completedAnswers) in lib/main.dart
- [x] T008 [US1] Implement initState with question shuffle logic in SoulSyncScreen in lib/main.dart
- [x] T009 [US1] Build split-screen layout with Transform.rotate for top player in lib/main.dart
- [x] T010 [US1] Implement _onAnswer method with setState for answer tracking in lib/main.dart
- [x] T011 [US1] Add auto-advance to next question when both players answered in lib/main.dart
- [x] T012 [US1] Add haptic feedback (mediumImpact) on O/X button tap in lib/main.dart
- [x] T013 [US1] Implement match calculation (_matches getter) in lib/main.dart
- [x] T014 [US1] Show basic result (match count, percent) when all 5 questions complete in lib/main.dart

**Checkpoint**: Full quiz flow works - two players answer 5 questions, see match result. MVP complete.

---

## Phase 4: User Story 2 - 결과 화면과 재시작 (Priority: P2)

**Goal**: Polished result screen with tiered messages, replay, and home navigation

**Independent Test**: After completing quiz, can see themed result message and tap "다시하기" or "홈으로"

### Implementation for User Story 2

- [x] T015 [US2] Add _resultMessage getter with 3-tier logic (≥80%, 50-79%, <50%) in lib/main.dart
- [x] T016 [US2] Build result overlay widget with FadeInUp animation in lib/main.dart
- [x] T017 [US2] Add tiered haptic feedback on result reveal (vibrate/medium/light) in lib/main.dart
- [x] T018 [US2] Add "다시하기" TossButton that resets game with new shuffled questions in lib/main.dart
- [x] T019 [US2] Add "홈으로" TossButton that navigates back to IntroScreen in lib/main.dart
- [x] T020 [US2] Add result emoji based on tier (🎉/😊/😅) in lib/main.dart

**Checkpoint**: Complete result experience with themed messages, haptics, and navigation options

---

## Phase 5: User Story 3 - 답변 대기 및 타이머 (Priority: P3)

**Goal**: Show waiting state when one player has answered, optional nudge timer

**Independent Test**: When one player answers, their area shows "기다리는 중~"

### Implementation for User Story 3

- [x] T021 [US3] Add _isWaitingForBoth getter to check if one player answered in lib/main.dart
- [x] T022 [US3] Show "기다리는 중~" text in answered player's area in lib/main.dart
- [x] T023 [US3] Disable O/X buttons for player who already answered in lib/main.dart
- [x] T024 [US3] Add optional 10-second timer with lightImpact nudge haptic in lib/main.dart

**Checkpoint**: Smooth waiting UX - answered player sees feedback, unanswered gets gentle nudge

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final polish and edge case handling

- [x] T025 [P] Add SafeArea wrapper to SoulSyncScreen in lib/main.dart
- [x] T026 [P] Add divider line between player areas in lib/main.dart
- [x] T027 Run dart format on lib/main.dart
- [ ] T028 Manual test on physical device per quickstart.md checklist
  - [ ] Haptic works on O/X tap
  - [ ] Haptic works on result reveal
  - [ ] Text readable from both orientations
  - [ ] Buttons large enough for comfortable tapping
  - [ ] Safe area respected (no notch overlap)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (needs SoulSyncScreen placeholder)
- **User Story 1 (Phase 3)**: Depends on Phase 2 (needs questions and components)
- **User Story 2 (Phase 4)**: Depends on US1 (needs game completion state)
- **User Story 3 (Phase 5)**: Depends on US1 (needs answer tracking state)
- **Polish (Phase 6)**: Depends on US1-3 completion

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - Core MVP
- **User Story 2 (P2)**: Depends on US1 completion (needs result state)
- **User Story 3 (P3)**: Depends on US1 completion (needs answer state), can run parallel with US2

### Within Each User Story

- State variables before methods
- Methods before UI that uses them
- Core flow before polish

### Parallel Opportunities

- T005 and T006 can run in parallel (independent components)
- T025 and T026 can run in parallel (independent polish tasks)
- US2 and US3 can potentially run in parallel after US1 complete

---

## Parallel Example: Phase 2

```bash
# Launch foundational tasks in parallel:
Task: "T005 [P] Create _buildOXButton helper method"
Task: "T006 [P] Create _PlayerArea widget"
```

## Parallel Example: Phase 6

```bash
# Launch polish tasks in parallel:
Task: "T025 [P] Add SafeArea wrapper"
Task: "T026 [P] Add divider line between player areas"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T006)
3. Complete Phase 3: User Story 1 (T007-T014)
4. **STOP and VALIDATE**: Test with two people on physical device
5. Deploy/demo if ready - this is a working MVP!

### Incremental Delivery

1. Complete Setup + Foundational → Navigation works
2. Add User Story 1 → Test independently → **MVP Complete**
3. Add User Story 2 → Test independently → Polished result experience
4. Add User Story 3 → Test independently → Smooth waiting UX
5. Complete Polish → Production ready

### Single Developer Flow

Since this is a single-file architecture:
1. Work through phases sequentially
2. Use parallel opportunities within phases when possible
3. Commit after each phase completion
4. Test on physical device after Phase 3 (MVP checkpoint)

---

## Notes

- All code goes in single `lib/main.dart` per Constitution Principle I
- [P] tasks = independent code blocks, no shared state dependencies
- [US#] label maps task to specific user story for traceability
- No automated tests per Constitution (MVP Phase - manual testing only)
- Commit after each phase or logical group
- Physical device required for haptic validation
