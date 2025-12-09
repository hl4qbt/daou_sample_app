# iOS IPA 테스트 설치 가이드 (인증서 없이)

## ⚠️ 중요 사항
서명 없는 IPA는 **직접 iPhone에 설치할 수 없습니다**. 하지만 무료 Apple ID를 사용하면 테스트용으로 설치할 수 있습니다.

## 방법 1: AltStore 사용 (가장 쉬움, Windows 지원)

### 준비물
- Windows PC
- iPhone
- USB 케이블
- 무료 Apple ID

### 설치 단계

#### 1. AltServer 설치
1. https://altstore.io 접속
2. "Download AltServer for Windows" 클릭
3. 설치 파일 실행 및 설치

#### 2. iTunes 설치 (필수)
- Windows에서 AltServer가 작동하려면 iTunes가 필요합니다
- https://www.apple.com/itunes/download 접속
- iTunes 설치

#### 3. AltStore를 iPhone에 설치
1. iPhone을 USB로 PC에 연결
2. AltServer 실행 (시스템 트레이에서 확인)
3. AltServer 아이콘 우클릭 → "Install AltStore" → iPhone 선택
4. Apple ID와 비밀번호 입력
5. iPhone에서 설정 → 일반 → VPN 및 기기 관리 → 개발자 앱 신뢰

#### 4. IPA 파일 설치
1. GitHub Actions에서 IPA 파일 다운로드
2. iPhone에서 AltStore 앱 실행
3. "+" 버튼 클릭
4. 다운로드한 IPA 파일 선택
5. 설치 완료!

**주의사항**:
- 7일마다 재서명 필요 (AltStore가 자동으로 처리)
- WiFi 동기화 설정 필요 (PC와 iPhone이 같은 네트워크에 있어야 함)

## 방법 2: Sideloadly 사용 (Windows/Mac 지원)

### 설치 단계
1. https://sideloadly.io 접속
2. Sideloadly 다운로드 및 설치
3. iPhone을 USB로 연결
4. IPA 파일 선택
5. Apple ID 입력
6. "Start" 클릭

**장점**: AltStore보다 간단하고 빠름
**단점**: 7일마다 수동으로 재설치 필요

## 방법 3: 3uTools 사용 (Windows)

### 설치 단계
1. https://www.3utools.com 다운로드
2. 3uTools 설치
3. iPhone을 USB로 연결
4. "Apps" 탭 → "Install" 클릭
5. IPA 파일 선택
6. 설치 완료

**주의사항**: 
- 개발자 인증서가 서명되지 않은 IPA는 설치할 수 없을 수 있음
- 일부 기능은 유료일 수 있음

## 방법 4: GitHub Actions에서 무료 Apple ID로 서명 (고급)

무료 Apple ID를 사용하여 GitHub Actions에서 서명된 IPA를 생성할 수 있습니다.

### 설정 방법

1. **무료 Apple ID 준비**
   - Apple ID가 필요합니다 (무료)
   - https://appleid.apple.com 에서 생성 가능

2. **인증서 생성 (macOS 필요)**
   - macOS 머신에서 Xcode 실행
   - Xcode → Preferences → Accounts
   - Apple ID 추가
   - "Manage Certificates" → "+" → "Apple Development" 선택
   - 인증서 다운로드

3. **인증서를 .p12로 내보내기**
   ```bash
   # Keychain Access에서 인증서 찾기
   # 인증서 우클릭 → Export → .p12 형식으로 저장
   ```

4. **프로비저닝 프로파일 생성**
   - Xcode에서 프로젝트 열기
   - Signing & Capabilities → Team 선택
   - "Automatically manage signing" 체크
   - Xcode가 자동으로 프로비저닝 프로파일 생성

5. **GitHub Secrets에 추가**
   - GitHub 저장소 → Settings → Secrets and variables → Actions
   - 다음 Secrets 추가:
     - `APPLE_CERTIFICATE`: .p12 파일을 Base64로 인코딩
     - `APPLE_CERTIFICATE_PASSWORD`: .p12 파일 비밀번호
     - `APPLE_PROVISIONING_PROFILE`: .mobileprovision 파일을 Base64로 인코딩

### Base64 인코딩 방법 (macOS)
```bash
# 인증서 인코딩
base64 -i certificate.p12 | pbcopy

# 프로비저닝 프로파일 인코딩
base64 -i profile.mobileprovision | pbcopy
```

## 방법 비교

| 방법 | 난이도 | 비용 | 기간 | 추천도 |
|------|--------|------|------|--------|
| AltStore | 쉬움 | 무료 | 7일 | ⭐⭐⭐⭐⭐ |
| Sideloadly | 쉬움 | 무료 | 7일 | ⭐⭐⭐⭐ |
| 3uTools | 쉬움 | 무료/유료 | 제한적 | ⭐⭐⭐ |
| GitHub Actions 서명 | 어려움 | 무료 | 7일 | ⭐⭐⭐ |

## 추천 방법

**Windows 사용자**: **AltStore** 또는 **Sideloadly** 사용
- AltStore: 자동 재서명, 편리함
- Sideloadly: 더 간단하고 빠름

**macOS 사용자**: Xcode를 통한 직접 설치 또는 AltStore

## 주의사항

1. **7일 제한**: 무료 Apple ID로 서명한 앱은 7일마다 재서명 필요
2. **기기 제한**: 무료 계정은 최대 3개 기기
3. **인증서 없이**: 서명 없는 IPA는 설치 불가능
4. **App Store 배포**: 무료 계정으로는 App Store 배포 불가

## 문제 해결

### AltStore 설치 실패
- iTunes가 설치되어 있는지 확인
- iPhone과 PC가 같은 WiFi에 연결되어 있는지 확인
- USB 케이블로 직접 연결 시도

### IPA 설치 실패
- 인증서가 서명되어 있는지 확인
- 7일이 지났는지 확인 (재서명 필요)
- 기기 제한 확인 (최대 3개)

## 결론

**가장 쉬운 방법**: AltStore 사용
- Windows에서도 사용 가능
- 자동 재서명 지원
- 무료

**가장 빠른 방법**: Sideloadly 사용
- 간단한 인터페이스
- 빠른 설치

인증서 없이도 테스트용으로 설치할 수 있습니다! 🎉





