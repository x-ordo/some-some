# Research: 이심전심 텔레파시 (Soul Sync)

**Date**: 2025-12-02
**Status**: Complete

## Research Areas

### 1. Split-Screen Layout with 180° Rotation

**Decision**: Use `Transform.rotate()` with `pi` radians for top player area

**Rationale**:
- Flutter's `Transform.rotate()` is GPU-accelerated and maintains 60fps
- Using `pi` (180°) ensures text and buttons are fully readable from the opposite direction
- `Column` with `Expanded` children naturally splits the screen 50/50

**Implementation Pattern**:
```dart
Column(
  children: [
    // Top Player (rotated 180°)
    Expanded(
      child: Transform.rotate(
        angle: pi,  // 180 degrees
        child: PlayerArea(playerId: 'A'),
      ),
    ),
    // Divider line
    Container(height: 2, color: TDS.textGrey),
    // Bottom Player (normal orientation)
    Expanded(
      child: PlayerArea(playerId: 'B'),
    ),
  ],
)
```

**Alternatives Considered**:
- `RotatedBox(quarterTurns: 2)` - Also works but less explicit about the rotation angle
- Custom painting - Overkill for this use case

---

### 2. Two-Player Simultaneous Input Handling

**Decision**: Use `setState` with map-based answer tracking

**Rationale**:
- Simple state management aligns with Constitution Principle I (Simplicity First)
- No external state management library needed
- Map structure allows easy comparison of answers

**Implementation Pattern**:
```dart
// State variables
Map<String, bool?> _currentAnswers = {'A': null, 'B': null};  // null = not answered
List<Map<String, bool>> _allAnswers = [];  // History of all Q&A rounds

void _onAnswer(String playerId, bool isO) {
  setState(() {
    _currentAnswers[playerId] = isO;

    // Check if both players have answered
    if (_currentAnswers['A'] != null && _currentAnswers['B'] != null) {
      _allAnswers.add(Map.from(_currentAnswers));
      _currentAnswers = {'A': null, 'B': null};
      _nextQuestion();
    }
  });
}
```

**Alternatives Considered**:
- Riverpod - Per Constitution, only add when "adding Mode B or C explicitly requires it". Since this IS Mode B, evaluate post-MVP if complexity warrants it
- BLoC pattern - Over-engineered for 5-question quiz flow

---

### 3. Question Data Structure

**Decision**: Hardcoded `List<String>` in code for MVP

**Rationale**:
- Firebase integration is planned for future but not MVP scope
- Hardcoded questions allow immediate testing without backend
- Easy to replace with remote fetch later

**Implementation Pattern**:
```dart
const List<String> _questions = [
  "첫 데이트는 활동적인 게 좋다",
  "연인 사이에 비밀은 없어야 한다",
  "기념일은 꼭 챙겨야 한다",
  "싸우면 먼저 연락해야 한다",
  "서로의 핸드폰을 볼 수 있어야 한다",
  // ... more questions for variety
];
```

**Question Selection**: Shuffle and pick first 5 at game start for replayability

**Alternatives Considered**:
- JSON asset file - Adds complexity without benefit for 10-15 hardcoded questions
- Firebase Remote Config - Future enhancement, not MVP

---

### 4. Result Calculation & Display

**Decision**: Simple match count with percentage + tiered messages

**Rationale**:
- Direct mapping to user story acceptance criteria
- Three tiers provide emotional variety without over-complication

**Implementation Pattern**:
```dart
int _calculateMatches() {
  return _allAnswers.where((round) => round['A'] == round['B']).length;
}

String _getResultMessage(int matches, int total) {
  final percent = (matches / total * 100).round();
  if (percent >= 80) return "천생연분!";
  if (percent >= 50) return "꽤 맞네?";
  return "이건 좀...";
}
```

**Haptic Feedback**:
- 80%+: `HapticFeedback.vibrate()` (celebration)
- 50-79%: `HapticFeedback.mediumImpact()`
- <50%: `HapticFeedback.lightImpact()` (gentle, not punishing)

---

### 5. O/X Button Design

**Decision**: Large circular buttons with emoji feedback

**Rationale**:
- O/X is universally understood in Korean quiz culture
- Large tap targets for face-to-face gameplay where precision is lower
- Emoji reinforces playful brand voice

**Implementation Pattern**:
```dart
Widget _buildAnswerButton({required bool isO, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      onTap();
    },
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isO ? TDS.primaryBlue : TDS.kitschPink,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          isO ? "O" : "X",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
  );
}
```

---

## Summary

All research items resolved. No external dependencies required. Implementation can proceed using:
- Built-in Flutter `Transform.rotate()` for split-screen
- Simple `setState` with map-based answer tracking
- Hardcoded question list shuffled per session
- Three-tier result messaging with appropriate haptics
- Large O/X buttons following TDS design patterns
