# Data Model: 이심전심 텔레파시 (Soul Sync)

**Date**: 2025-12-02
**Storage**: In-memory only (no persistence)

## Entities

### Question

Represents a single O/X question in the quiz.

| Field | Type | Description |
|-------|------|-------------|
| `text` | `String` | Question text displayed to both players |

**Notes**:
- Questions are hardcoded as `List<String>` for MVP
- Future: Firebase Remote Config integration for dynamic questions

**Example Data**:
```dart
const List<String> questions = [
  "첫 데이트는 활동적인 게 좋다",
  "연인 사이에 비밀은 없어야 한다",
  "기념일은 꼭 챙겨야 한다",
  "싸우면 먼저 연락해야 한다",
  "서로의 핸드폰을 볼 수 있어야 한다",
  "데이트 비용은 번갈아 내야 한다",
  "같은 취미가 있어야 한다",
  "자기 전에 통화해야 한다",
  "친구들에게 연애 사실을 알려야 한다",
  "여행은 둘이만 가야 한다",
];
```

---

### Answer

Represents one player's answer to a question.

| Field | Type | Description |
|-------|------|-------------|
| `playerId` | `String` | Player identifier: `'A'` (top/rotated) or `'B'` (bottom) |
| `value` | `bool` | `true` = O (agree), `false` = X (disagree) |

**In-Code Representation**:
```dart
// Current round answers (nullable until answered)
Map<String, bool?> _currentAnswers = {'A': null, 'B': null};
```

---

### GameSession

Represents the complete game state for one Soul Sync session.

| Field | Type | Description |
|-------|------|-------------|
| `questions` | `List<String>` | Shuffled subset of 5 questions for this session |
| `currentIndex` | `int` | Index of current question (0-4) |
| `answers` | `List<Map<String, bool>>` | History of all completed rounds |
| `isComplete` | `bool` | Whether all 5 questions have been answered |

**State Transitions**:
```
[INITIAL] → [PLAYING] → [WAITING_BOTH] → [NEXT_QUESTION] → ... → [COMPLETE]

INITIAL: Game screen loaded, showing first question
PLAYING: Both players see question, neither has answered
WAITING_BOTH: One player answered, waiting for other
NEXT_QUESTION: Both answered, transitioning to next (or to results if done)
COMPLETE: All 5 questions answered, showing results
```

**In-Code Representation**:
```dart
class _SoulSyncScreenState extends State<SoulSyncScreen> {
  // Questions
  late List<String> _questions;
  int _currentIndex = 0;

  // Answers
  Map<String, bool?> _currentAnswers = {'A': null, 'B': null};
  List<Map<String, bool>> _completedAnswers = [];

  // Game state
  bool get _isComplete => _completedAnswers.length >= 5;
  bool get _isWaitingForBoth =>
      _currentAnswers['A'] != null || _currentAnswers['B'] != null;
}
```

---

### Result

Represents the final game result (computed, not stored).

| Field | Type | Description |
|-------|------|-------------|
| `matches` | `int` | Number of matching answers (0-5) |
| `total` | `int` | Total questions (always 5) |
| `percent` | `int` | Match percentage (0-100) |
| `message` | `String` | Result message based on tier |
| `tier` | `String` | `'high'` (≥80%), `'medium'` (50-79%), `'low'` (<50%) |

**Tier Mapping**:
| Tier | Percent | Message | Haptic |
|------|---------|---------|--------|
| `high` | ≥80% | "천생연분!" | `vibrate()` |
| `medium` | 50-79% | "꽤 맞네?" | `mediumImpact()` |
| `low` | <50% | "이건 좀..." | `lightImpact()` |

**Computation**:
```dart
int get _matches =>
    _completedAnswers.where((r) => r['A'] == r['B']).length;

int get _percent => (_matches / 5 * 100).round();

String get _resultMessage {
  if (_percent >= 80) return "천생연분!";
  if (_percent >= 50) return "꽤 맞네?";
  return "이건 좀...";
}
```

---

## Relationships

```
GameSession
    ├── contains → List<Question> (5 shuffled from pool)
    ├── tracks → List<Answer> pairs per round
    └── computes → Result (on completion)
```

## Validation Rules

1. **Player IDs**: Must be exactly `'A'` or `'B'`
2. **Answer values**: Must be exactly `true` (O) or `false` (X)
3. **Question count**: Session must have exactly 5 questions
4. **Completion**: Both players must answer before advancing
5. **No double-answer**: A player cannot change their answer once submitted
