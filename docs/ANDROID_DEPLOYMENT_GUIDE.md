# Android 배포 가이드 - 썸썸 v2.0.0

## 사전 요구사항

1. **Android Studio** (최신 버전)
2. **Android SDK** (API 34+)
3. **Java 17** (JDK)
4. **Google Play Developer** 계정 ($25 일회성)

---

## 1단계: 서명 키 생성

### Keystore 생성
```bash
cd android

keytool -genkeypair -v \
  -storetype JKS \
  -keystore some_some_release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias some_some
```

프롬프트에 다음 정보 입력:
- Keystore password: (안전한 비밀번호)
- Key password: (안전한 비밀번호)
- 이름, 조직, 국가 등

### key.properties 생성
```bash
cp key.properties.example key.properties
```

`android/key.properties` 수정:
```properties
storeFile=some_some_release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=some_some
keyPassword=YOUR_KEY_PASSWORD
```

> **중요:** `key.properties`와 `.jks` 파일은 절대 Git에 커밋하지 마세요!

---

## 2단계: 빌드

### App Bundle (권장)
```bash
flutter build appbundle --release
```

출력 위치: `build/app/outputs/bundle/release/app-release.aab`

### APK (테스트용)
```bash
flutter build apk --release
```

출력 위치: `build/app/outputs/flutter-apk/app-release.apk`

---

## 3단계: Google Play Console 설정

### 앱 생성
1. [Google Play Console](https://play.google.com/console) 접속
2. "앱 만들기" 클릭
3. 정보 입력:
   - 앱 이름: 썸썸
   - 기본 언어: 한국어
   - 앱 유형: 앱
   - 무료/유료: 무료 (인앱 구매 있음)

### 스토어 등록정보
1. "스토어 등록정보" → "기본 스토어 등록정보"
2. 메타데이터 입력 (`docs/GOOGLE_PLAY_METADATA.md` 참조):
   - 짧은 설명 (80자)
   - 전체 설명
   - 그래픽 자산 업로드

### 콘텐츠 등급
1. "정책" → "앱 콘텐츠" → "콘텐츠 등급"
2. 질문지 응답:
   - 폭력: 없음
   - 성적 콘텐츠: 가벼운 로맨스 테마
   - 언어: 없음
   - 음주: 술자리 게임 관련 언급
3. 등급 확인: 12세 이상

### 앱 카테고리
- 카테고리: 엔터테인먼트
- 태그: 캐주얼, 소셜, 파티게임

---

## 4단계: 인앱 결제 설정

### 상품 등록
1. "수익 창출" → "인앱 상품"
2. "상품 만들기" 클릭
3. 상품 추가:

| 상품 ID | 이름 | 가격 |
|---------|------|------|
| com.prometheusp.somesome.premium | 프리미엄 업그레이드 | ₩3,900 |
| com.prometheusp.somesome.spicy_pack | 스파이시 질문 팩 | ₩1,900 |
| com.prometheusp.somesome.couple_pack | 커플 질문 팩 | ₩1,900 |

### 라이선스 테스터 추가
1. "설정" → "라이선스 테스트"
2. 테스터 이메일 추가
3. 라이선스 응답: "LICENSED"

---

## 5단계: 내부 테스트

### 내부 테스트 트랙 생성
1. "테스트" → "내부 테스트"
2. "새 버전 만들기"
3. AAB 파일 업로드
4. 출시 노트 입력
5. "검토 시작"

### 테스터 초대
1. "테스터" 탭
2. 이메일 목록 추가 또는 Google 그룹 사용
3. 테스트 링크 공유

---

## 6단계: 프로덕션 출시

### 사전 준비
- [ ] 내부 테스트 완료
- [ ] 모든 정책 준수 확인
- [ ] 콘텐츠 등급 받음
- [ ] 스토어 등록정보 완성
- [ ] 인앱 상품 활성화

### 프로덕션 출시
1. "프로덕션" → "새 버전 만들기"
2. 내부 테스트에서 버전 승격 또는 새 AAB 업로드
3. 출시 노트 입력
4. "검토 시작"

### 검토 시간
- 신규 앱: 1-7일
- 업데이트: 수 시간 ~ 1일

---

## 빌드 스크립트

### build_release.sh
```bash
#!/bin/bash
set -e

echo "=== 썸썸 Android Release Build ==="

# Clean
flutter clean
flutter pub get

# Build AAB
flutter build appbundle --release

# Output info
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB_PATH" ]; then
    SIZE=$(du -h "$AAB_PATH" | cut -f1)
    echo ""
    echo "✅ Build successful!"
    echo "📦 AAB: $AAB_PATH"
    echo "📏 Size: $SIZE"
else
    echo "❌ Build failed!"
    exit 1
fi
```

---

## 문제 해결

### Keystore 오류
```
Execution failed for task ':app:signReleaseBundle'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.Workers$ActionFacade
```

해결:
1. `key.properties` 경로 확인
2. `.jks` 파일 존재 확인
3. 비밀번호 확인

### ProGuard 오류
```
Warning: ... can't find referenced class ...
```

해결:
`android/app/proguard-rules.pro`에 규칙 추가:
```
-dontwarn com.example.missing.Class
```

### 64비트 미지원 오류
Flutter 기본값으로 arm64-v8a, armeabi-v7a 모두 포함됨.

---

## 체크리스트

### 빌드 전
- [ ] `pubspec.yaml` 버전 확인 (2.0.0+19)
- [ ] `key.properties` 설정 완료
- [ ] `.jks` 파일 안전한 곳에 백업
- [ ] 인앱 상품 ID 일치 확인

### 업로드 전
- [ ] AAB 빌드 성공
- [ ] 스크린샷 준비 (1080x1920)
- [ ] 그래픽 이미지 준비 (1024x500)
- [ ] 고해상도 아이콘 준비 (512x512)

### 출시 전
- [ ] 콘텐츠 등급 완료
- [ ] 개인정보처리방침 URL 활성화
- [ ] 앱 카테고리 설정
- [ ] 인앱 상품 활성화
- [ ] 내부 테스트 완료

---

## 버전 히스토리

| 버전 | 버전코드 | 내용 |
|------|----------|------|
| 2.0.0 | 19 | 대규모 업데이트: 룰렛, 커플모드, IAP |
| 1.9.0 | 18 | 바이럴 최적화, 딥링크 |
| 1.8.0 | 17 | 커플 모드 추가 |
| 1.7.0 | 16 | 복불복 룰렛 추가 |
| 1.6.0 | 15 | 콘텐츠 확충 (질문 50개) |

---

## 유용한 링크

- [Google Play Console](https://play.google.com/console)
- [Android 앱 서명](https://developer.android.com/studio/publish/app-signing)
- [출시 체크리스트](https://developer.android.com/distribute/best-practices/launch/launch-checklist)
- [인앱 결제 테스트](https://developer.android.com/google/play/billing/test)

---

*Last Updated: 2025-12-27*
