# Quickstart: 이심전심 텔레파시 (Soul Sync)

## Prerequisites

- Flutter 3.x installed
- Physical iOS/Android device (haptics don't work in simulator)
- Two people for face-to-face testing

## Run the App

```bash
# From project root
cd /Users/admin/Documents/dev/some-some

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

## Test Soul Sync Feature

### 1. Access Soul Sync

1. Launch the app → **IntroScreen** appears
2. Tap **"이심전심 텔레파시"** button
3. **SoulSyncScreen** loads with split-screen layout

### 2. Verify Split-Screen Layout

- Screen should be divided in half horizontally
- **Top half**: Rotated 180° (for person sitting opposite)
- **Bottom half**: Normal orientation
- Both halves show the same question

### 3. Play One Round

1. **Both players** read the question (e.g., "첫 데이트는 활동적인 게 좋다")
2. **Player A** (top) taps O or X
   - Verify: Haptic feedback on tap
   - Verify: "기다리는 중~" appears in their area
3. **Player B** (bottom) taps O or X
   - Verify: Haptic feedback on tap
   - Verify: Screen auto-advances to next question

### 4. Complete All Questions

- Answer all 5 questions
- Verify: Each question advances automatically after both answer

### 5. Verify Results Screen

| Scenario | Expected |
|----------|----------|
| 4-5 matches (≥80%) | "천생연분!" + celebration haptic |
| 3 matches (60%) | "꽤 맞네?" + medium haptic |
| 0-2 matches (<50%) | "이건 좀..." + light haptic |

### 6. Test Navigation

- Tap **"다시하기"** → New game with shuffled questions
- Tap **"홈으로"** → Returns to IntroScreen

## Edge Case Testing

| Test | Steps | Expected |
|------|-------|----------|
| One player waits | Player A answers, Player B doesn't | A sees "기다리는 중~", no timeout |
| Rapid tapping | Both tap at nearly same time | Both answers register, advances |
| Back gesture | Swipe back during game | Returns to Intro (game state lost - acceptable for MVP) |

## Performance Validation

```bash
# Run with performance overlay
flutter run --profile

# Check for:
# - UI thread < 16ms (60fps)
# - No frame drops during transitions
```

## Physical Device Checklist

- [ ] Haptic works on O/X tap
- [ ] Haptic works on result reveal
- [ ] Text readable from both orientations
- [ ] Buttons large enough for comfortable tapping
- [ ] Safe area respected (no notch overlap)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No haptic feedback | Must test on physical device, not simulator |
| Top player can't read text | Verify `Transform.rotate(angle: pi)` applied |
| Game doesn't advance | Check both players actually tapped (not just touched) |
