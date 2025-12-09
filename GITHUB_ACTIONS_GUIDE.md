# GitHub Actions를 통한 iOS 원격 빌드 완전 가이드

## 📋 목차
1. [GitHub Actions란?](#github-actions란)
2. [작동 원리](#작동-원리)
3. [초기 설정](#초기-설정)
4. [워크플로우 파일 설명](#워크플로우-파일-설명)
5. [실제 사용 방법](#실제-사용-방법)
6. [빌드 결과 확인](#빌드-결과-확인)
7. [서명 설정 (선택사항)](#서명-설정-선택사항)
8. [문제 해결](#문제-해결)
9. [비용 및 제한사항](#비용-및-제한사항)

---

## GitHub Actions란?

**GitHub Actions**는 GitHub에서 제공하는 CI/CD(Continuous Integration/Continuous Deployment) 플랫폼입니다.

### 주요 특징
- ✅ **무료**: 공개 저장소는 완전 무료
- ✅ **자동화**: 코드 푸시 시 자동 빌드
- ✅ **macOS 지원**: iOS 빌드를 위한 macOS 러너 제공
- ✅ **간편한 설정**: YAML 파일로 설정
- ✅ **빌드 결과 다운로드**: IPA 파일 자동 다운로드 가능

### 왜 필요한가?
- Windows에서 iOS 빌드 불가 → 원격 macOS에서 빌드
- 로컬 Mac 없이도 iOS 앱 개발 가능
- 자동화된 빌드 파이프라인 구축

---

## 작동 원리

```
[Windows PC]                    [GitHub]                    [GitHub Actions]
     │                              │                              │
     │ 1. 코드 푸시                  │                              │
     ├─────────────────────────────>│                              │
     │                              │                              │
     │                              │ 2. 워크플로우 트리거          │
     │                              ├─────────────────────────────>│
     │                              │                              │
     │                              │                              │ 3. macOS 러너 시작
     │                              │                              │ (가상 Mac 머신)
     │                              │                              │
     │                              │                              │ 4. 코드 체크아웃
     │                              │                              │ 5. Flutter 설치
     │                              │                              │ 6. CocoaPods 설치
     │                              │                              │ 7. pod install
     │                              │                              │ 8. flutter build ipa
     │                              │                              │
     │                              │                              │ 9. IPA 파일 생성
     │                              │                              │
     │                              │ 10. 빌드 결과 저장            │
     │                              │<─────────────────────────────│
     │                              │                              │
     │ 11. Artifacts에서 다운로드    │                              │
     │<─────────────────────────────│                              │
```

---

## 초기 설정

### 1단계: GitHub 저장소 준비

#### 저장소가 없는 경우
```bash
# Git 초기화
git init

# 파일 추가
git add .

# 첫 커밋
git commit -m "Initial commit"

# GitHub에서 새 저장소 생성 후
git remote add origin https://github.com/yourusername/daou_sample_app.git
git branch -M main
git push -u origin main
```

#### 이미 저장소가 있는 경우
```bash
# 현재 상태 확인
git status

# 변경사항 커밋
git add .
git commit -m "Add GitHub Actions workflow"

# 푸시
git push
```

### 2단계: 워크플로우 파일 확인

프로젝트에 이미 `.github/workflows/ios-build.yml` 파일이 있습니다.

**파일 위치**: `.github/workflows/ios-build.yml`

### 3단계: 워크플로우 활성화

1. GitHub 저장소로 이동
2. **Actions** 탭 클릭
3. 왼쪽 사이드바에서 **"Build iOS"** 워크플로우 확인
4. 첫 실행은 수동으로 트리거하거나 코드 푸시 시 자동 실행

---

## 워크플로우 파일 설명

현재 프로젝트의 `.github/workflows/ios-build.yml` 파일을 단계별로 설명합니다.

### 전체 구조

```yaml
name: Build iOS                    # 워크플로우 이름

on:                                # 트리거 조건
  workflow_dispatch:               # 수동 실행
  push:                            # 푸시 시 자동 실행
    branches: [ main, master ]
  pull_request:                    # PR 생성 시 실행
    branches: [ main, master ]

jobs:                              # 작업 정의
  build-ios:                       # 작업 이름
    runs-on: macos-latest          # macOS 러너 사용
    steps:                         # 실행 단계
      # ... 각 단계들
```

### 단계별 상세 설명

#### 1. 코드 체크아웃
```yaml
- name: Checkout code
  uses: actions/checkout@v3
```
**역할**: GitHub 저장소의 코드를 가상 머신에 다운로드

#### 2. Flutter 설치
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.10.3'
    channel: 'stable'
```
**역할**: 
- Flutter SDK 설치
- 지정된 버전(3.10.3) 설치
- 안정 채널 사용

**버전 변경 방법**: `flutter-version` 값을 원하는 버전으로 변경

#### 3. CocoaPods 설치
```yaml
- name: Install CocoaPods
  run: |
    sudo gem install cocoapods
    pod --version
```
**역할**: 
- CocoaPods 설치 (iOS 의존성 관리 도구)
- 설치 확인

#### 4. Flutter 의존성 설치
```yaml
- name: Get Flutter dependencies
  run: |
    flutter pub get
```
**역할**: 루트 디렉토리의 `pubspec.yaml` 의존성 설치

#### 5. Example 앱 의존성 설치
```yaml
- name: Get example dependencies
  run: |
    cd example
    flutter pub get
```
**역할**: example 앱의 의존성 설치

#### 6. iOS 의존성 설치 (pod install)
```yaml
- name: Install iOS dependencies
  run: |
    cd example/ios
    pod install
    cd ../..
```
**역할**: 
- iOS 네이티브 의존성 설치
- `Podfile` 기반으로 CocoaPods 의존성 해결
- **이 단계가 핵심입니다!**

#### 7. iOS 빌드 (서명 없이)
```yaml
- name: Build iOS IPA
  run: |
    cd example
    flutter build ipa --release --no-codesign
  continue-on-error: true
```
**역할**: 
- 서명 없이 IPA 빌드 (테스트용)
- 실패해도 다음 단계 계속 진행

#### 8. iOS 빌드 (서명 포함, 선택사항)
```yaml
- name: Build iOS IPA (with codesign if credentials available)
  if: ${{ secrets.APPLE_CERTIFICATE != '' }}
  env:
    APPLE_CERTIFICATE: ${{ secrets.APPLE_CERTIFICATE }}
    # ...
  run: |
    # 인증서 설정 및 빌드
```
**역할**: 
- Apple Developer 인증서가 있는 경우에만 실행
- 서명된 IPA 생성 (실제 배포용)

#### 9. 빌드 결과 업로드
```yaml
- name: Upload IPA artifact
  uses: actions/upload-artifact@v3
  with:
    name: ios-ipa
    path: example/build/ios/ipa/*.ipa
    retention-days: 30
```
**역할**: 
- 생성된 IPA 파일을 Artifacts에 업로드
- 30일간 보관
- 다운로드 가능

---

## 실제 사용 방법

### 방법 1: 자동 실행 (코드 푸시 시)

```bash
# Windows에서
git add .
git commit -m "Update code"
git push
```

**결과**: 
- GitHub에 푸시되면 자동으로 빌드 시작
- Actions 탭에서 진행 상황 확인

### 방법 2: 수동 실행

1. GitHub 저장소 → **Actions** 탭
2. 왼쪽에서 **"Build iOS"** 선택
3. **"Run workflow"** 버튼 클릭
4. 브랜치 선택 (보통 `main`)
5. **"Run workflow"** 클릭

**사용 시기**:
- 특정 시점에만 빌드하고 싶을 때
- 자동 빌드 없이 수동으로 제어하고 싶을 때

### 방법 3: Pull Request 시 실행

```bash
# 새 브랜치 생성
git checkout -b feature/new-feature

# 변경사항 커밋
git add .
git commit -m "Add new feature"

# 푸시
git push origin feature/new-feature

# GitHub에서 Pull Request 생성
```

**결과**: PR 생성 시 자동으로 빌드 실행

---

## 빌드 결과 확인

### 1. 빌드 진행 상황 확인

1. GitHub 저장소 → **Actions** 탭
2. 실행 중인 워크플로우 클릭
3. 각 단계의 로그 확인

### 2. 빌드 성공 확인

✅ **성공 표시**: 
- 각 단계에 초록색 체크 표시
- "Upload IPA artifact" 단계 완료

### 3. IPA 파일 다운로드

1. 워크플로우 실행 페이지에서
2. 오른쪽 **"Artifacts"** 섹션 확인
3. **"ios-ipa"** 클릭
4. 다운로드 버튼 클릭

**다운로드 파일**: 
- `ios-ipa.zip` (IPA 파일 포함)
- 압축 해제 후 `.ipa` 파일 사용

### 4. 빌드 실패 시

❌ **실패 표시**: 
- 빨간색 X 표시
- 실패한 단계 확인

**확인 사항**:
1. 로그 확인 (실패한 단계 클릭)
2. 에러 메시지 확인
3. 코드 문제 또는 설정 문제 확인

---

## 서명 설정 (선택사항)

서명된 IPA를 생성하려면 Apple Developer 계정이 필요합니다.

### 1. Apple Developer 계정 준비

- **무료 계정**: Apple ID로 가능 (제한적)
- **유료 계정**: $99/년 (App Store 배포 가능)

### 2. 인증서 및 프로비저닝 프로파일 생성

**macOS에서 실행**:
1. Xcode 실행
2. Preferences → Accounts → Apple ID 추가
3. "Manage Certificates" → 인증서 생성
4. 프로젝트 → Signing & Capabilities → 자동 서명 활성화

### 3. GitHub Secrets 설정

1. GitHub 저장소 → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** 클릭
3. 다음 Secrets 추가:

#### APPLE_CERTIFICATE
- **이름**: `APPLE_CERTIFICATE`
- **값**: Base64 인코딩된 `.p12` 인증서 파일
- **생성 방법**:
  ```bash
  # macOS에서
  base64 -i certificate.p12 | pbcopy
  ```

#### APPLE_CERTIFICATE_PASSWORD
- **이름**: `APPLE_CERTIFICATE_PASSWORD`
- **값**: 인증서 비밀번호

#### APPLE_PROVISIONING_PROFILE
- **이름**: `APPLE_PROVISIONING_PROFILE`
- **값**: Base64 인코딩된 `.mobileprovision` 파일
- **생성 방법**:
  ```bash
  # macOS에서
  base64 -i profile.mobileprovision | pbcopy
  ```

### 4. 서명된 빌드 확인

Secrets 설정 후 다음 빌드부터:
- "Build iOS IPA (with codesign if credentials available)" 단계 실행
- 서명된 IPA 생성

---

## 문제 해결

### 문제 1: 워크플로우가 실행되지 않음

**원인**: 
- `.github/workflows/ios-build.yml` 파일이 없음
- 파일이 잘못된 위치에 있음

**해결**:
```bash
# 파일 위치 확인
ls .github/workflows/ios-build.yml

# 없으면 생성
mkdir -p .github/workflows
# 파일 생성 (이미 있음)
```

### 문제 2: "pod install" 실패

**에러 예시**:
```
[!] CocoaPods could not find compatible versions
```

**해결**:
1. `example/ios/Podfile` 확인
2. CocoaPods 버전 확인
3. 워크플로우에서 CocoaPods 버전 명시:
   ```yaml
   - name: Install CocoaPods
     run: |
       sudo gem install cocoapods -v 1.15.2
       pod --version
   ```

### 문제 3: Flutter 버전 불일치

**에러 예시**:
```
The current Flutter SDK version is 3.x.x
```

**해결**:
```yaml
# 워크플로우에서 Flutter 버전 변경
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.19.0'  # 원하는 버전으로 변경
```

### 문제 4: 빌드 시간 초과

**원인**: 
- 빌드가 너무 오래 걸림
- 무료 플랜의 시간 제한

**해결**:
- 불필요한 단계 제거
- 캐시 사용 (추가 설정 필요)

### 문제 5: IPA 파일이 생성되지 않음

**확인 사항**:
1. 빌드 로그에서 에러 확인
2. `example/build/ios/ipa/` 경로 확인
3. 서명 문제인지 확인 (`--no-codesign` 사용 시)

**해결**:
```yaml
# 빌드 단계 수정
- name: Build iOS IPA
  run: |
    cd example
    flutter build ipa --release --no-codesign
    ls -la build/ios/ipa/  # 파일 확인
```

### 문제 6: 의존성 해결 실패

**에러 예시**:
```
Error: Could not find package
```

**해결**:
1. `pubspec.yaml` 확인
2. `pubspec.lock` 확인
3. 의존성 버전 호환성 확인

---

## 비용 및 제한사항

### 무료 플랜 (공개 저장소)

✅ **무제한**:
- 빌드 시간
- 저장소 수
- 워크플로우 실행

### 무료 플랜 (비공개 저장소)

⚠️ **제한사항**:
- 월 2,000분 무료
- 초과 시 분당 $0.008 (약 $0.48/시간)

### macOS 러너

- **macos-latest**: 최신 macOS 버전
- **macos-13**: macOS 13 (Ventura)
- **macos-12**: macOS 12 (Monterey)

**비용**: 
- 공개 저장소: 무료
- 비공개 저장소: 분당 $0.08 (약 $4.80/시간)

### 빌드 시간

- **일반적인 Flutter iOS 빌드**: 5-15분
- **첫 빌드**: 더 오래 걸릴 수 있음 (의존성 다운로드)

### Artifacts 저장

- **보관 기간**: 최대 90일 (현재 30일로 설정)
- **크기 제한**: 10GB (일반적으로 충분)

---

## 고급 설정

### 1. 빌드 캐시 사용

빌드 시간 단축을 위해 캐시 추가:

```yaml
- name: Cache CocoaPods
  uses: actions/cache@v3
  with:
    path: example/ios/Pods
    key: ${{ runner.os }}-pods-${{ hashFiles('example/ios/Podfile.lock') }}

- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      example/.dart_tool
    key: ${{ runner.os }}-flutter-${{ hashFiles('pubspec.lock') }}
```

### 2. 여러 Flutter 버전 테스트

```yaml
strategy:
  matrix:
    flutter-version: ['3.10.3', '3.19.0', 'stable']
steps:
  - name: Setup Flutter
    uses: subosito/flutter-action@v2
    with:
      flutter-version: ${{ matrix.flutter-version }}
```

### 3. 빌드 알림 설정

```yaml
- name: Notify on failure
  if: failure()
  uses: actions/github-script@v6
  with:
    script: |
      github.rest.issues.create({
        owner: context.repo.owner,
        repo: context.repo.repo,
        title: 'iOS Build Failed',
        body: 'The iOS build has failed. Please check the Actions tab.'
      })
```

### 4. 특정 브랜치에서만 실행

```yaml
on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main
```

---

## 체크리스트

빌드 전 확인 사항:

- [ ] `.github/workflows/ios-build.yml` 파일 존재
- [ ] `pubspec.yaml` 파일 유효
- [ ] `example/pubspec.yaml` 파일 유효
- [ ] Git 저장소에 푸시 완료
- [ ] GitHub Actions 활성화 확인
- [ ] (선택) Apple Developer 인증서 설정

---

## 요약

### ✅ 장점
- Windows에서 iOS 빌드 가능
- 완전 자동화
- 무료 (공개 저장소)
- 간편한 설정

### ⚠️ 주의사항
- 빌드 시간 소요 (5-15분)
- 인터넷 연결 필요
- 서명 설정은 추가 작업 필요

### 🚀 다음 단계
1. 코드 푸시
2. Actions 탭에서 빌드 확인
3. IPA 다운로드
4. iPhone에 설치

---

## 참고 자료

- [GitHub Actions 공식 문서](https://docs.github.com/en/actions)
- [Flutter CI/CD 가이드](https://docs.flutter.dev/deployment/cd)
- [CocoaPods 가이드](https://guides.cocoapods.org/)
- [Apple Developer 문서](https://developer.apple.com/documentation/)

---

**질문이나 문제가 있으면 Issues 탭에서 문의하세요!** 🎉

