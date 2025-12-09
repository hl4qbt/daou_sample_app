# iOS 시뮬레이터 실행 가이드

## ⚠️ 중요 사항
**Windows OS에서는 iOS 시뮬레이터와 실물 iPhone 모두 직접 실행할 수 없습니다.** 
- iOS 시뮬레이터는 macOS에서만 실행 가능합니다.
- 실물 iPhone에 앱을 빌드하고 설치하려면 Xcode가 필요하며, Xcode는 macOS에서만 동작합니다.

## macOS에서 iOS 시뮬레이터 실행 방법

### 1. 필수 요구사항
- macOS 운영체제 (MacBook, iMac, Mac mini 등)
- Xcode 설치 (App Store에서 다운로드)
- Flutter SDK 설치

### 2. Xcode 설정
```bash
# Xcode Command Line Tools 설치
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Xcode 라이선스 동의
sudo xcodebuild -license accept
```

### 3. Flutter iOS 설정 확인
```bash
# Flutter 의존성 확인
flutter doctor

# iOS 시뮬레이터 확인
flutter emulators

# 사용 가능한 시뮬레이터 목록 보기
xcrun simctl list devices
```

### 4. iOS 시뮬레이터 실행 방법

#### 방법 1: Flutter 명령어 사용
```bash
# example 폴더로 이동
cd example

# iOS 시뮬레이터 자동 실행 및 앱 실행
flutter run -d ios

# 특정 시뮬레이터 지정
flutter run -d "iPhone 15 Pro"
```

#### 방법 2: Android Studio에서 실행
1. Android Studio에서 프로젝트 열기
2. 상단 디바이스 선택 드롭다운 클릭
3. "Open iOS Simulator" 선택 (macOS에서만 표시됨)
4. 또는 "Device Manager" → "iOS Simulators" 탭에서 시뮬레이터 선택
5. Run 버튼 클릭

#### 방법 3: Xcode에서 직접 실행
```bash
# Xcode에서 프로젝트 열기
cd example/ios
open Runner.xcworkspace

# Xcode에서 시뮬레이터 선택 및 실행
# Product → Destination → 원하는 시뮬레이터 선택
# Product → Run (⌘R)
```

### 5. 시뮬레이터 디바이스 관리
```bash
# 시뮬레이터 목록 보기
xcrun simctl list devices

# 시뮬레이터 부팅
xcrun simctl boot "iPhone 15 Pro"

# 시뮬레이터 종료
xcrun simctl shutdown "iPhone 15 Pro"

# 시뮬레이터 앱 실행
open -a Simulator
```

## 실물 iPhone에서 실행하기 (macOS 필요)

### 1. 필수 요구사항
- macOS 운영체제
- Xcode 설치
- Apple Developer 계정 (무료 계정도 가능)
- USB 케이블로 연결된 iPhone
- iPhone에서 "신뢰" 확인

### 2. iPhone 설정
1. iPhone 설정 → 일반 → VPN 및 기기 관리
2. 개발자 앱 신뢰 설정 (처음 실행 시)

### 3. Xcode에서 디바이스 등록
1. iPhone을 USB로 Mac에 연결
2. Xcode 실행
3. Window → Devices and Simulators
4. 연결된 iPhone 선택
5. "Use for Development" 클릭
6. Apple ID로 로그인하여 디바이스 등록

### 4. Flutter로 실물 iPhone 실행
```bash
# example 폴더로 이동
cd example

# 연결된 디바이스 확인
flutter devices

# 실물 iPhone에 앱 실행
flutter run -d <device-id>

# 또는 자동으로 iPhone 감지하여 실행
flutter run
```

### 5. Android Studio에서 실물 iPhone 실행
1. iPhone을 USB로 Mac에 연결
2. Android Studio에서 프로젝트 열기
3. 상단 디바이스 선택 드롭다운에서 연결된 iPhone 선택
4. Run 버튼 클릭
5. 처음 실행 시 Xcode에서 서명 설정 필요

### 6. 코드 서명 설정 (처음 한 번만)
```bash
# Xcode에서 프로젝트 열기
cd example/ios
open Runner.xcworkspace

# Xcode에서:
# 1. 왼쪽 프로젝트 네비게이터에서 "Runner" 선택
# 2. "Signing & Capabilities" 탭 선택
# 3. "Automatically manage signing" 체크
# 4. Team에서 Apple ID 선택 (또는 Apple Developer 계정)
```

### 7. 문제 해결
```bash
# 연결된 디바이스 확인
flutter devices

# iPhone이 보이지 않는 경우
# 1. USB 케이블 확인
# 2. iPhone에서 "이 컴퓨터를 신뢰하시겠습니까?" 확인
# 3. Xcode → Window → Devices and Simulators에서 디바이스 등록 확인

# 빌드 오류 발생 시
cd example
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

## Windows에서의 대안

### 1. Android 에뮬레이터 사용
```bash
# Android 에뮬레이터에서 실행
cd example
flutter run -d android
```

### 2. 클라우드 Mac 서비스 사용
- **MacStadium**: 클라우드 Mac 인스턴스 제공
- **AWS EC2 Mac**: AWS에서 macOS 인스턴스 제공
- **MacinCloud**: 원격 Mac 접속 서비스
- **Codemagic**: CI/CD 서비스 (무료 플랜 제공, macOS 빌드 가능)
- **AppCircle**: CI/CD 서비스 (iOS 빌드 지원)

### 3. 원격 Mac 접속
- macOS 머신에 원격 접속 (TeamViewer, VNC, SSH 등)
- 원격에서 Xcode 및 시뮬레이터/실물 디바이스 실행

### 4. CI/CD 서비스를 통한 빌드 (실물 디바이스 테스트는 제한적)
일부 CI/CD 서비스에서 iOS 빌드를 할 수 있지만, 실물 디바이스에 직접 설치하려면:
- **Codemagic**: macOS 빌드 머신 제공, IPA 파일 생성 가능
- **GitHub Actions**: macOS runner 사용 가능
- 생성된 IPA 파일을 다운로드하여 macOS에서 설치하거나 TestFlight 사용

⚠️ **주의**: Windows에서 직접 실물 iPhone에 앱을 설치하는 것은 불가능합니다. 
- iOS 앱 빌드에는 Xcode가 필요하며, Xcode는 macOS 전용입니다.
- USB로 iPhone을 연결해도 Windows에서는 개발자 모드로 인식되지 않습니다.

## 문제 해결

### Flutter doctor 이슈 확인
```bash
flutter doctor -v
```

### iOS 시뮬레이터가 보이지 않는 경우
```bash
# CocoaPods 설치 (iOS 의존성 관리)
sudo gem install cocoapods

# example 프로젝트의 iOS 의존성 설치
cd example/ios
pod install
cd ../..
```

### 시뮬레이터 실행 오류
```bash
# Flutter 클린 빌드
cd example
flutter clean
flutter pub get
flutter run -d ios
```

## 참고 자료
- [Flutter iOS 설정 가이드](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode 시뮬레이터 가이드](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device)

