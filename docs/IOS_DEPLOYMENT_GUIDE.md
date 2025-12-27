# iOS 배포 가이드 - 썸썸 v2.0.0

## 사전 요구사항

1. **macOS 환경**
2. **Xcode 15.0+** (Full installation)
3. **CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```
4. **Apple Developer Program** 가입 ($99/년)
5. **App Store Connect** 앱 등록

---

## 1단계: 환경 설정

### Xcode 설정
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### Flutter 의존성 설치
```bash
flutter pub get
cd ios && pod install && cd ..
```

---

## 2단계: App Store Connect 설정

### 앱 생성
1. [App Store Connect](https://appstoreconnect.apple.com) 접속
2. "My Apps" → "+" → "New App"
3. 정보 입력:
   - Name: 썸썸
   - Primary Language: Korean
   - Bundle ID: com.prometheusp.somesome
   - SKU: somesome-ios

### 인앱 결제 상품 등록
1. "In-App Purchases" → "+"
2. 상품 추가:

   | 상품 ID | 유형 | 가격 |
   |---------|------|------|
   | com.prometheusp.somesome.premium | Non-Consumable | ₩3,900 |
   | com.prometheusp.somesome.spicy_pack | Non-Consumable | ₩1,900 |
   | com.prometheusp.somesome.couple_pack | Non-Consumable | ₩1,900 |

---

## 3단계: 서명 설정

### 인증서 생성
1. Xcode → Preferences → Accounts → Team
2. "Manage Certificates" → "+" → "Apple Distribution"

### Provisioning Profile
1. [Apple Developer Portal](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles
3. Profiles → "+" → "App Store"
4. App ID: com.prometheusp.somesome 선택

### ExportOptions.plist 수정
`ios/ExportOptions.plist`의 `teamID`를 실제 Team ID로 변경:
```xml
<key>teamID</key>
<string>XXXXXXXXXX</string>  <!-- 실제 Team ID 입력 -->
```

---

## 4단계: 빌드 및 아카이브

### Release 빌드
```bash
flutter build ios --release
```

### Xcode에서 아카이브
```bash
open ios/Runner.xcworkspace
```

1. Product → Scheme → Runner
2. Any iOS Device (arm64) 선택
3. Product → Archive
4. Window → Organizer에서 아카이브 확인

### CLI로 아카이브 (선택)
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/ipa
```

---

## 5단계: TestFlight 업로드

### Xcode Organizer에서
1. Archive 선택
2. "Distribute App" 클릭
3. "App Store Connect" → "Upload"
4. 자동 서명 선택
5. 업로드 완료 대기

### Transporter 사용 (선택)
```bash
xcrun altool --upload-app \
  -f build/ipa/Runner.ipa \
  -t ios \
  -u your@email.com \
  -p @keychain:AC_PASSWORD
```

---

## 6단계: 심사 제출

### App Store Connect에서
1. TestFlight → 빌드 확인 (처리 완료 대기: ~30분)
2. "App Store" 탭 → "+" 버전 추가
3. 메타데이터 입력:
   - 스크린샷 업로드
   - 설명, 키워드 입력 (`docs/APP_STORE_METADATA.md` 참조)
   - 프로모션 텍스트
4. 빌드 선택
5. "Submit for Review"

---

## 체크리스트

### 빌드 전
- [ ] `pubspec.yaml` 버전 확인 (2.0.0+19)
- [ ] 인앱 결제 상품 ID 일치 확인
- [ ] 딥링크 스킴 설정 확인 (somesome://)
- [ ] 앱 아이콘 1024x1024 준비

### 업로드 전
- [ ] 스크린샷 모든 사이즈 준비
- [ ] 개인정보 처리방침 URL 활성화
- [ ] 지원 URL 활성화
- [ ] 연령 등급 질문 응답

### 심사 전
- [ ] 심사 노트 작성
- [ ] 인앱 결제 테스트 완료
- [ ] 모든 기능 정상 동작 확인

---

## 문제 해결

### "Application not configured for iOS"
```bash
flutter create . --platforms ios
flutter clean && flutter pub get
cd ios && pod install && cd ..
```

### Signing 오류
1. Xcode → Runner → Signing & Capabilities
2. Team 선택
3. "Automatically manage signing" 체크

### Pod 오류
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install
```

---

## 버전 히스토리

| 버전 | 빌드 | 내용 |
|------|------|------|
| 2.0.0 | 19 | 대규모 업데이트: 룰렛, 커플모드, IAP |
| 1.9.0 | 18 | 바이럴 최적화, 딥링크 |
| 1.8.0 | 17 | 커플 모드 추가 |
| 1.7.0 | 16 | 복불복 룰렛 추가 |
| 1.6.0 | 15 | 콘텐츠 확충 (질문 50개) |

---

*Last Updated: 2025-12-27*
