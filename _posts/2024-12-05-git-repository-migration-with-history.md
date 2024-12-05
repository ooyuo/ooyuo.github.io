---
title: "Git Repository 이전하기: 커밋 히스토리 유지와 충돌 해결하기"
date: 2024-12-05
categories:
  - Development
  - Git
tags:
  - Git
  - Repository Migration
  - Version Control
  - Git History
  - Merge Conflicts
  - DevOps
  - Git Commands
  - Technical Guide
---

## 배경

최근 팀 내 인프라 개편으로 인해 기존에 관리하던 GitLab 레포지토리의 권한이 인프라팀으로 이관되었다. 이에 따라 기존 레포지토리 A에서 새로운 레포지토리 B로 프로젝트를 이전해야 하는 상황이 발생했다.

## 문제 상황

레포지토리를 이전하면서 마주친 까다로운 점은 다음과 같았다:

![image.png](/assets/img/posts/2024-12-05/2024-12-05-git-repository-migration-with-history.png)

1. 기존 레포지토리 A의 커밋 히스토리를 모두 유지해야 했다.
2. 새로운 레포지토리 B에는 이미 누군가가 레포지토리 A의 폴더 내용을 복사해서 푸시해둔 상태였다.
3. 레포지토리 B에는 이미 몇 가지 수정사항이 추가되어 있었다.

## 해결 과정

이 문제를 해결하기 위해 다음과 같은 단계로 진행했다.

### 1. 새 레포지토리 준비

먼저 레포지토리 B를 로컬에 클론했다.

```bash
git clone [repository-B-url]
cd [repository-B-directory]
```

### 2. 기존 레포지토리 연결

레포지토리 A를 리모트로 추가했다.

```bash
git remote add old-repo [repository-A-url]
git fetch old-repo
```

### 3. 히스토리 병합

기존 히스토리를 가져오기 위해 임시 브랜치를 만들고 병합을 진행했다.

```bash
# 레포지토리 A의 히스토리를 새 브랜치로 가져오기
git checkout -b temp-branch old-repo/main

# 메인 브랜치로 돌아가기
git checkout main

# 두 히스토리 병합하기
git merge temp-branch --allow-unrelated-histories
```

### 4. 충돌 해결

예상대로 많은 파일에서 충돌이 발생했다. 다음 단계로 충돌을 해결했다:

1. 충돌 파일 확인

```bash
git status
```

1. 각 충돌 파일을 열어 수동으로 해결
    - `<<<<<<<`, `=======`, `>>>>>>>` 마커로 표시된 부분을 확인
    - 최신 변경사항을 유지하면서 필요한 히스토리는 보존
2. 충돌 해결 후 커밋

```bash
git add .
git commit -m "Merge repository A history with existing changes"
git push origin main
```

## 배운 점

1. `-allow-unrelated-histories` 옵션의 중요성
    - 서로 관련 없는 두 저장소의 히스토리를 병합할 때 필수적인 옵션이었다.
2. 사전 준비의 중요성
    - 중요 데이터는 반드시 백업해두어야 한다.
    - 팀원들과의 커뮤니케이션이 필요하다.
3. 체계적인 접근
    - 단계별로 진행하고 각 단계에서 결과를 확인하는 것이 중요하다.
    - 문제 발생 시 이전 단계로 돌아갈 수 있도록 준비해야 한다.

## 결론

Git을 사용하다 보면 레포지토리 이전이나 병합 같은 작업은 피할 수 없다. 이런 상황에서 커밋 히스토리를 잃지 않고 안전하게 이전하는 것은 매우 중요하다. 이번 경험을 통해 Git의 고급 기능을 활용하는 방법과 체계적인 문제 해결 과정의 중요성을 다시 한번 배울 수 있었다.