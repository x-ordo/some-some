# App Store Release Checklist

## Pre-Release

### Code Quality
- [ ] `flutter analyze` - 0 errors
- [ ] `flutter test` - all passing
- [ ] No debug prints or TODO comments
- [ ] Version updated in `pubspec.yaml`

### Current Version: 1.2.2+6
```yaml
version: 1.2.2+6
# format: major.minor.patch+buildNumber
```

---

## Android (Google Play Store)

### 1. Keystore Setup
```bash
# Generate release keystore (one-time)
keytool -genkeypair -v \
  -storetype JKS \
  -keystore some_some_release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias some_some

# Store the keystore file securely (NOT in git)
# Location: android/some_some_release.jks
```

### 2. Configure Signing
```bash
# Copy and edit key.properties
cp android/key.properties.example android/key.properties

# Edit android/key.properties:
storeFile=some_some_release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=some_some
keyPassword=YOUR_KEY_PASSWORD
```

### 3. Build Release APK/AAB
```bash
# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab

# Or build APK for testing
flutter build apk --release
```

### 4. Play Console Setup
- [ ] Create app in Google Play Console
- [ ] Package name: `com.prometheusp.somesome`
- [ ] Upload AAB to internal testing first
- [ ] Fill in store listing (use `store/google-play/ko-KR/listing.md`)
- [ ] Add screenshots (see `SCREENSHOTS_GUIDE.md`)
- [ ] Set content rating
- [ ] Set pricing (Free)
- [ ] Configure countries/regions

### 5. Review & Release
- [ ] Internal testing → Closed testing → Open testing → Production
- [ ] Review time: 1-7 days typically

---

## iOS (App Store)

### 1. Apple Developer Account
- [ ] Active Apple Developer Program membership ($99/year)
- [ ] App ID created: `com.prometheusp.somesome`

### 2. Xcode Configuration
```bash
# Open Xcode project
open ios/Runner.xcworkspace
```

**Required Settings:**
- [ ] Bundle Identifier: `com.prometheusp.somesome`
- [ ] Display Name: `썸썸`
- [ ] Version: `1.2.2`
- [ ] Build: `6`
- [ ] Deployment Target: iOS 13.0+
- [ ] Signing Team: Your Apple Developer Team

### 3. Build Archive
```bash
# Build iOS release
flutter build ios --release

# Then in Xcode:
# Product > Archive
# Distribute App > App Store Connect
```

### 4. App Store Connect Setup
- [ ] Create new app in App Store Connect
- [ ] Bundle ID: `com.prometheusp.somesome`
- [ ] Fill in App Information
- [ ] Add app description (use `store/app-store/ko/listing.md`)
- [ ] Upload screenshots for all device sizes
- [ ] Set age rating (4+)
- [ ] Set pricing (Free)
- [ ] Configure availability

### 5. Submit for Review
- [ ] Upload build via Xcode or Transporter
- [ ] Select build in App Store Connect
- [ ] Fill in "What's New" notes
- [ ] Submit for App Review
- [ ] Review time: 1-2 days typically

---

## Post-Release

### Monitor
- [ ] Check crash reports (Crashlytics if configured)
- [ ] Monitor user reviews
- [ ] Track downloads/installs

### Updates
- Increment version in `pubspec.yaml`
- Increment build number for each submission
- Update "What's New" / Release Notes

---

## Version History

| Version | Build | Date | Notes |
|---------|-------|------|-------|
| 1.0.0 | 1 | - | MVP Launch |
| 1.0.1 | 2 | - | Phase 1 UX Hotfix |
| 1.1.0 | 3 | - | Sound, Tutorial, Confetti |
| 1.2.0 | 4 | - | Share, Settings, Difficulty |
| 1.2.1 | 5 | - | Sound files added |
| 1.2.2 | 6 | - | Heartbeat sound fix |

---

## Support Links

- **Privacy Policy:** https://prometheusp.com/somesome/privacy
- **Support:** https://prometheusp.com/somesome/support
- **Contact:** contact@prometheusp.com

---

*Last updated: 2025-12-27*
