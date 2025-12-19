# Store Submission Checklist (v3)

이 레포는 **심사 제출 직전 단계**까지의 코드/구조를 포함합니다.
단, **서명키/애플 개발자 서명/스토어 업로드**는 계정이 필요하므로 로컬에서 수행해야 합니다.

## 1) 공통 필수
- [ ] `lib/core/app_links.dart`의 URL 3개를 실제 링크로 교체
  - privacyPolicyUrl, supportUrl, storeUrl
- [ ] 스토어용 스크린샷 준비(최소 3~5장)
- [ ] 앱 설명/키워드/연령등급/문의 이메일 준비

## 2) Android (Google Play)
### 2-1. 패키지 ID
- `android/app/build.gradle.kts`:
  - namespace / applicationId = `com.prometheusp.somesome` (이미 설정됨)

### 2-2. 릴리즈 서명
1. `android/key.properties.example`를 `android/key.properties`로 복사
2. keystore 생성 (예시)
   ```bash
   cd android
   keytool -genkeypair -v -storetype JKS -keystore some_some_release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias some_some
   ```
3. `android/key.properties` 값 채우기
4. AAB 빌드
   ```bash
   flutter build appbundle --release
   ```

## 3) iOS (App Store)
### 3-1. 번들 ID
- `ios/Runner.xcodeproj/project.pbxproj`에 `com.prometheusp.somesome`가 설정되어 있음.

### 3-2. 아카이브
1. Xcode 열기: `ios/Runner.xcworkspace`
2. Signing & Capabilities에서 Team 선택
3. `Product > Archive`
4. Organizer에서 App Store Connect 업로드

## 4) 아이콘/스플래시 교체
`assets/branding/icon.png`, `assets/branding/splash.png`를 교체한 뒤:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

