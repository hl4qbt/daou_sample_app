# macOS에서 iOS 빌드 및 iPhone 설치 가이드

## ✅ macOS에서 직접 빌드하는 것이 가장 확실합니다

### 장점
- ✅ **간단함**: 복잡한 설정 불필요
- ✅ **빠름**: 로컬 빌드로 즉시 확인
- ✅ **디버깅 용이**: 에러를 바로 확인하고 수정
- ✅ **실물 기기 테스트**: USB로 직접 연결하여 테스트
- ✅ **무료 Apple ID 사용 가능**: 개발자 계정 없이도 테스트 가능

---

## 1. 필수 준비사항

### 하드웨어
- macOS가 설치된 Mac (MacBook, iMac, Mac mini 등)
- iPhone (테스트용)

### 소프트웨어
- Xcode (App Store에서 무료 다운로드)
- Flutter SDK

---

## 2. Xcode 설치 및 설정

### 2.1 Xcode 설치
1. Mac App Store에서 "Xcode" 검색
2. "받기" 또는 "다운로드" 클릭
3. 설치 완료 대기 (용량이 크므로 시간이 걸림)

### 2.2 Xcode Command Line Tools 설정
```bash
# 터미널에서 실행
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Xcode 라이선스 동의
sudo xcodebuild -license accept
```

### 2.3 Xcode에서 Apple ID 로그인
1. Xcode 실행
2. Xcode → Settings (또는 Preferences) → Accounts
3. 왼쪽 하단 "+" 버튼 클릭
4. "Apple ID" 선택
5. Apple ID와 비밀번호 입력
6. 로그인 완료

---

## 3. Flutter 설정

### 3.1 Flutter 설치 확인
```bash
# Flutter 설치 확인
flutter doctor

# iOS 관련 이슈 확인
flutter doctor -v
```

### 3.2 CocoaPods 설치
```bash
# CocoaPods 설치
sudo gem install cocoapods

# 설치 확인
pod --version
```

---

## 4. 프로젝트 설정

### 4.1 프로젝트로 이동
```bash
cd /path/to/daou_sample_app/example
```

### 4.2 의존성 설치
```bash
# Flutter 의존성
flutter pub get

# iOS 의존성 (CocoaPods)
cd ios
pod install
cd ..
```

---

## 5. Xcode에서 서명 설정

### 5.1 Xcode에서 프로젝트 열기
```bash
cd example/ios
open Runner.xcworkspace
```

### 5.2 서명 설정
1. Xcode에서 왼쪽 프로젝트 네비게이터에서 **"Runner"** 프로젝트 클릭
2. 상단에서 **"Runner"** 타겟 선택
3. **"Signing & Capabilities"** 탭 클릭
4. **"Automatically manage signing"** 체크
5. **"Team"** 드롭다운에서 Apple ID 선택
   - 처음이면 "Add an Account..." 클릭하여 Apple ID 추가
6. Bundle Identifier가 고유한지 확인
   - 예: `com.yourname.daouSampleAppExample`

### 5.3 서명 확인
- ✅ "Signing Certificate"에 "Apple Development" 표시
- ✅ "Provisioning Profile" 자동 생성됨

---

## 6. iPhone 연결 및 설정

### 6.1 iPhone을 Mac에 연결
1. USB 케이블로 iPhone을 Mac에 연결
2. iPhone에서 "이 컴퓨터를 신뢰하시겠습니까?" → **"신뢰"** 선택

### 6.2 iPhone에서 개발자 모드 활성화 (iOS 16+)
1. iPhone 설정 → 개인정보 보호 및 보안
2. "개발자 모드" 활성화
3. iPhone 재시작
4. 재시작 후 "개발자 모드를 켜시겠습니까?" → **"켜기"** 선택

### 6.3 Xcode에서 디바이스 등록
1. Xcode → Window → Devices and Simulators
2. 연결된 iPhone 확인
3. "Use for Development" 클릭 (처음 연결 시)
4. Apple ID로 로그인하여 디바이스 등록

---

## 7. 빌드 및 실행

### 방법 1: Flutter 명령어 사용 (가장 쉬움)

```bash
# example 폴더에서
cd example

# 연결된 iPhone에 자동 실행
flutter run

# 또는 특정 디바이스 지정
flutter devices
flutter run -d <device-id>
```

### 방법 2: Xcode에서 직접 실행

1. Xcode에서 `Runner.xcworkspace` 열기
2. 상단 디바이스 선택에서 연결된 iPhone 선택
3. **⌘R** (또는 Product → Run)
4. 빌드 및 설치 자동 진행

### 방법 3: IPA 파일 생성

```bash
# example 폴더에서
cd example

# IPA 파일 생성 (서명 포함)
flutter build ipa --release

# 생성된 IPA 파일 위치
# build/ios/ipa/*.ipa
```

---

## 8. IPA 파일을 iPhone에 설치

### 방법 1: Xcode를 통한 설치
1. Xcode → Window → Devices and Simulators
2. 연결된 iPhone 선택
3. IPA 파일을 드래그 앤 드롭
4. 설치 완료

### 방법 2: Finder를 통한 설치
1. Finder에서 IPA 파일 찾기
2. 연결된 iPhone을 Finder에서 열기
3. IPA 파일을 드래그 앤 드롭
4. 설치 완료

### 방법 3: AltStore/Sideloadly 사용
- Windows에서 다운로드한 IPA 파일을 macOS로 전송
- AltStore나 Sideloadly로 설치

---

## 9. 문제 해결

### 문제 1: "No devices found"
**해결**:
```bash
# 디바이스 확인
flutter devices

# iPhone이 보이지 않으면
# 1. USB 케이블 확인
# 2. iPhone에서 "신뢰" 확인
# 3. 개발자 모드 활성화 확인
```

### 문제 2: "Development Team" 오류
**해결**:
1. Xcode → Settings → Accounts
2. Apple ID 확인
3. Xcode에서 프로젝트 → Signing & Capabilities → Team 선택

### 문제 3: "Code signing is required"
**해결**:
1. Xcode에서 프로젝트 열기
2. Signing & Capabilities → "Automatically manage signing" 체크
3. Team 선택

### 문제 4: "App installation failed"
**해결**:
1. iPhone 설정 → 일반 → VPN 및 기기 관리
2. 개발자 앱에서 신뢰 설정
3. iPhone 재시작

### 문제 5: CocoaPods 오류
**해결**:
```bash
cd example/ios
pod deintegrate
pod install
```

---

## 10. 무료 Apple ID vs 유료 계정

### 무료 Apple ID (개인 개발용)
- ✅ **비용**: 무료
- ✅ **테스트**: 가능
- ⚠️ **제한**: 7일마다 재서명 필요
- ⚠️ **기기 제한**: 최대 3개
- ❌ **App Store 배포**: 불가

### 유료 계정 ($99/년)
- ✅ **비용**: $99/년
- ✅ **테스트**: 가능
- ✅ **서명 기간**: 1년
- ✅ **기기 제한**: 없음
- ✅ **App Store 배포**: 가능
- ✅ **TestFlight**: 사용 가능

---

## 11. 빌드 최적화

### Release 빌드
```bash
# 최적화된 Release 빌드
flutter build ipa --release

# 특정 아키텍처만 빌드 (빠름)
flutter build ipa --release --split-debug-info=build/debug-info
```

### 빌드 시간 단축
```bash
# 캐시 사용
flutter build ipa --release --no-tree-shake-icons
```

---

## 12. 자주 사용하는 명령어

```bash
# 의존성 설치
flutter pub get
cd ios && pod install && cd ..

# 클린 빌드
flutter clean
flutter pub get
cd ios && pod install && cd ..

# 디바이스 확인
flutter devices

# 빌드
flutter build ipa --release

# 실행
flutter run

# 로그 확인
flutter logs
```

---

## 13. GitHub Actions vs macOS 직접 빌드

| 항목 | GitHub Actions | macOS 직접 빌드 |
|------|----------------|----------------|
| **설정 난이도** | 어려움 ⭐⭐⭐⭐⭐ | 쉬움 ⭐⭐ |
| **빌드 시간** | 5-15분 | 2-5분 |
| **디버깅** | 어려움 | 쉬움 |
| **실물 기기 테스트** | 불가능 | 가능 |
| **비용** | 무료 (공개) | 무료 |
| **안정성** | 중간 | 높음 |

---

## 결론

**macOS에서 직접 빌드하는 것이 가장 확실하고 간단합니다!**

### 추천 워크플로우
1. **개발**: macOS에서 직접 빌드 및 테스트
2. **CI/CD**: GitHub Actions는 Android 빌드만 사용
3. **배포**: macOS에서 IPA 생성 후 TestFlight/App Store 업로드

### 다음 단계
1. Mac 준비
2. Xcode 설치
3. 프로젝트 열기
4. 서명 설정
5. 빌드 및 실행!

**macOS가 있다면 바로 시작하세요!** 🚀


