# GitHub 푸시 가이드

## 인증 문제 해결

Windows Credential Manager에 저장된 이전 인증 정보가 문제일 수 있습니다.

## 방법 1: Windows Credential Manager에서 삭제

1. **Windows 검색**에서 "자격 증명 관리자" 또는 "Credential Manager" 검색
2. **Windows 자격 증명** 탭 선택
3. `git:https://github.com` 또는 `github.com` 관련 항목 찾기
4. 항목 클릭 → **제거** 클릭

## 방법 2: URL에 토큰 직접 포함 (임시)

```bash
# 토큰을 URL에 포함 (보안상 권장하지 않지만 테스트용)
git remote set-url origin https://hl4qbt:YOUR_TOKEN@github.com/hl4qbt/daou_sample_app.git
git push -u origin main
```

⚠️ **주의**: 이 방법은 명령어 히스토리에 토큰이 남을 수 있으므로 사용 후 즉시 제거하세요.

## 방법 3: Git Credential Helper 사용

```bash
# 자격 증명 저장 안 함
git config --global credential.helper ""

# 또는 Windows Credential Manager 사용
git config --global credential.helper manager-core
```

## 방법 4: GitHub CLI 사용 (권장)

```bash
# GitHub CLI 설치 (없는 경우)
winget install GitHub.cli

# GitHub CLI로 로그인
gh auth login

# 브라우저에서 인증 후
git push -u origin main
```

## 추천 순서

1. Windows Credential Manager에서 기존 GitHub 인증 정보 삭제
2. `git push -u origin main` 다시 시도
3. 비밀번호 프롬프트에 Personal Access Token 입력
4. 실패 시 GitHub CLI 사용





