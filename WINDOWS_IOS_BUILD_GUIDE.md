# Windows에서 iOS 빌드 및 iPhone 실행 가이드

## ⚠️ 핵심 사항
Windows에서 **직접** iOS 빌드는 불가능하지만, **원격 빌드 서비스**를 통해 IPA 파일을 생성하고 iPhone에 설치할 수 있습니다.

## 방법 1: GitHub Actions를 사용한 원격 빌드 (추천)

### 장점
- 무료 (공개 저장소)
- 자동화 가능
- IPA 파일 자동 다운로드

### 설정 방법

#### 1. GitHub 저장소에 프로젝트 푸시
```bash
# Git 초기화 (아직 안 했다면)
git init
git add .
git commit -m "Initial commit"

# GitHub에 저장소 생성 후
git remote add origin https://github.com/yourusername/daou_sample_app.git
git push -u origin main
```

#### 2. GitHub Actions 워크플로우 생성

`.github/workflows/ios-build.yml` 파일 생성:

```yaml
name: Build iOS

on:
  workflow_dispatch:  # 수동 실행
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-ios:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.3'
        channel: 'stable'
    
    - name: Install CocoaPods
      run: |
        sudo gem install cocoapods
        pod --version
    
    - name: Install dependencies
      run: |
        cd example
        flutter pub get
        cd ios
        pod install
        cd ../..
    
    - name: Build iOS IPA
      run: |
        cd example
        flutter build ipa --release
    
    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: ios-ipa
        path: example/build/ios/ipa/*.ipa
        retention-days: 30
```

#### 3. 사용 방법
1. GitHub 저장소의 "Actions" 탭으로 이동
2. "Build iOS" 워크플로우 선택
3. "Run workflow" 클릭
4. 빌드 완료 후 "Artifacts"에서 IPA 파일 다운로드

### IPA를 iPhone에 설치하는 방법

#### 방법 A: macOS가 있는 경우
```bash
# IPA 다운로드 후
# Xcode → Window → Devices and Simulators
# iPhone 연결 후 IPA 드래그 앤 드롭
```

#### 방법 B: Windows에서 직접 설치 (제한적)
- **3uTools** (Windows용 iOS 앱 설치 도구)
- **iMazing** (유료, Windows 지원)
- **AltStore** (자체 서명 필요)

⚠️ **주의**: 개발자 인증서가 필요한 경우, Apple Developer 계정이 필요합니다.

## 방법 2: Codemagic 사용 (추천 - 가장 쉬움)

### 장점
- 무료 플랜 제공 (월 500분)
- GUI 기반 설정
- 자동 서명 및 배포
- TestFlight 자동 업로드 가능

### 설정 방법

#### 1. Codemagic 가입
- https://codemagic.io 접속
- GitHub 계정으로 로그인

#### 2. 프로젝트 연결
1. "Add application" 클릭
2. GitHub 저장소 선택
3. Flutter 프로젝트로 인식

#### 3. iOS 빌드 설정
1. "Configure workflow" 클릭
2. iOS 플랫폼 선택
3. `example` 폴더를 워킹 디렉토리로 설정
4. Apple Developer 계정 연결 (서명용)

#### 4. 빌드 스크립트 (자동 생성되지만 수정 가능)
```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Get dependencies
        script: |
          flutter pub get
          cd example
          flutter pub get
          cd ios
          pod install
          cd ../..
      - name: Build iOS
        script: |
          cd example
          flutter build ipa --release
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      email:
        recipients:
          - your-email@example.com
```

#### 5. 빌드 실행
- Codemagic 대시보드에서 "Start new build" 클릭
- 빌드 완료 후 IPA 다운로드 또는 TestFlight 업로드

## 방법 3: AppCircle 사용

### 장점
- 무료 플랜 제공
- GUI 기반 설정
- 자동 서명

### 설정
1. https://appcircle.io 접속
2. GitHub 저장소 연결
3. iOS 빌드 프로필 생성
4. 빌드 실행 및 IPA 다운로드

## 방법 4: 원격 Mac 서비스 사용

### 서비스 목록
- **MacStadium**: 클라우드 Mac 인스턴스
- **AWS EC2 Mac**: AWS macOS 인스턴스
- **MacinCloud**: 원격 Mac 데스크톱

### 사용 방법
1. 서비스 가입 및 Mac 인스턴스 생성
2. 원격 접속 (RDP, VNC, SSH)
3. Flutter 및 Xcode 설치
4. 프로젝트 클론 및 빌드
5. IPA 생성 후 다운로드

## 방법 5: 로컬 네트워크의 Mac 사용

### Windows에서 Mac으로 빌드 요청
Mac이 같은 네트워크에 있다면:

#### Mac에서 SSH 서버 설정
```bash
# Mac에서
sudo systemsetup -setremotelogin on
```

#### Windows에서 빌드 스크립트 실행
```powershell
# Windows PowerShell에서
ssh username@mac-ip-address "cd /path/to/project && flutter build ipa --release"
scp username@mac-ip-address:/path/to/project/example/build/ios/ipa/*.ipa ./
```

## IPA 설치 방법 상세

### 방법 1: Xcode 사용 (macOS 필요)
1. iPhone을 USB로 Mac에 연결
2. Xcode 실행
3. Window → Devices and Simulators
4. 연결된 iPhone 선택
5. IPA 파일을 드래그 앤 드롭

### 방법 2: 3uTools 사용 (Windows)
1. https://www.3utools.com 다운로드
2. iPhone 연결
3. "Apps" 탭 → "Install" 클릭
4. IPA 파일 선택

⚠️ **주의**: 개발자 인증서가 서명되지 않은 IPA는 설치할 수 없습니다.

### 방법 3: TestFlight 사용 (가장 안정적)
1. Apple Developer 계정 필요 ($99/년)
2. App Store Connect에서 앱 등록
3. IPA를 App Store Connect에 업로드
4. TestFlight에서 테스터 초대
5. iPhone에서 TestFlight 앱으로 설치

## Apple Developer 계정 설정

### 무료 계정 (개인 개발용)
- 제한: 7일마다 재서명 필요
- 최대 3개 기기
- App Store 배포 불가

### 유료 계정 ($99/년)
- 1년 유효 서명
- 무제한 기기
- App Store 배포 가능
- TestFlight 사용 가능

## 프로젝트별 설정

### 현재 프로젝트 (daou_sample_app) 설정

#### 1. Bundle Identifier 확인
`example/ios/Runner.xcodeproj/project.pbxproj`에서:
```
PRODUCT_BUNDLE_IDENTIFIER = com.example.daouSampleAppExample;
```

#### 2. 서명 설정 (Xcode에서)
```bash
# Mac에서 Xcode 열기
cd example/ios
open Runner.xcworkspace
```

Xcode에서:
- Runner 프로젝트 선택
- "Signing & Capabilities" 탭
- "Automatically manage signing" 체크
- Team 선택 (Apple ID)

#### 3. 빌드 스크립트 수정
CI/CD에서 사용할 경우, 서명 정보를 환경 변수로 설정:

```yaml
# GitHub Actions 예시
env:
  APPLE_CERTIFICATE: ${{ secrets.APPLE_CERTIFICATE }}
  APPLE_CERTIFICATE_PASSWORD: ${{ secrets.APPLE_CERTIFICATE_PASSWORD }}
  APPLE_PROVISIONING_PROFILE: ${{ secrets.APPLE_PROVISIONING_PROFILE }}
```

## 문제 해결

### 빌드 실패 시
```bash
# Flutter 클린 빌드
cd example
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ipa --release
```

### 서명 오류
- Apple Developer 계정 확인
- Bundle Identifier 고유성 확인
- Provisioning Profile 확인

### CocoaPods 오류
```bash
cd example/ios
pod deintegrate
pod install
```

## 추천 워크플로우

### 개발 단계
1. Windows에서 코드 작성
2. Android 에뮬레이터로 테스트
3. GitHub에 푸시

### iOS 테스트 단계
1. GitHub Actions 또는 Codemagic으로 빌드
2. IPA 다운로드
3. TestFlight 또는 직접 설치로 테스트

### 배포 단계
1. App Store Connect에 업로드
2. TestFlight 베타 테스트
3. App Store 제출

## 비용 비교

| 방법 | 비용 | 난이도 | 추천도 |
|------|------|--------|--------|
| GitHub Actions | 무료 (공개) | 중 | ⭐⭐⭐⭐ |
| Codemagic | 무료 플랜 | 쉬움 | ⭐⭐⭐⭐⭐ |
| AppCircle | 무료 플랜 | 쉬움 | ⭐⭐⭐⭐ |
| 원격 Mac | $20-100/월 | 어려움 | ⭐⭐ |
| 로컬 Mac | 무료 | 중 | ⭐⭐⭐ |

## 결론

**가장 추천하는 방법:**
1. **Codemagic** - 가장 쉬운 설정, 무료 플랜
2. **GitHub Actions** - 완전 무료, 자동화 가능
3. **TestFlight** - 가장 안정적인 배포 방법

Windows에서도 충분히 iOS 앱을 개발하고 배포할 수 있습니다! 🚀

