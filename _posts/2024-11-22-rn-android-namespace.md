---
date: 2024-11-22 14:00:00 +0900
categories: [React Native, Android]
tags: [react-native, android, namespace, automation]
---


## 문제 상황

최근 React Native 프로젝트를 업그레이드하는 과정에서 골치 아픈 문제가 발생했다. 안드로이드 빌드 시 각 라이브러리마다 namespace를 일일이 추가해줘야 하는 상황이었다. 특히 `node_modules`를 삭제하고 재설치할 때마다 이 작업을 반복해야 했는데, 이는 매우 비효율적이고 시간 낭비였다.

처음에는 Android Studio에서 각 라이브러리의 build.gradle 파일을 열어 수동으로 namespace를 추가했다. 하지만 20개가 넘는 라이브러리에 대해 이 작업을 반복하는 것은 너무 고통스러웠다. 특히 새로운 팀원이 프로젝트를 셋업할 때마다 이런 불편함을 겪어야 한다는 점이 마음에 걸렸다.

## 해결 과정

이 문제를 자동화하기 위해 세 가지 주요 작업을 진행했다.

### 1. package.json에 postinstall 스크립트 추가

먼저 `npm install` 실행 시 자동으로 namespace를 추가하도록 package.json의 scripts에 postinstall을 추가했다.

```json
"scripts": {
  "postinstall": "node scripts/add-namespaces.ts && patch-package"
}

```

### 2. gradle.properties에 namespace 정보 추가

안드로이드 빌드 시스템이 참조할 수 있도록 `android/gradle.properties` 파일에 각 라이브러리의 namespace를 정의했다.

```
android.enableNamespaceCheck=true
react-native-gesture-handler.namespace=com.swmansion.gesturehandler
react-native-webview.namespace=com.reactnativecommunity.webview
# ... 기타 라이브러리들의 namespace

```

이렇게 하면 프로젝트에서 사용하는 모든 라이브러리의 namespace를 한 곳에서 관리할 수 있다.

### 3. namespace 자동 추가 스크립트 작성

가장 핵심적인 부분은 `scripts/add-namespaces.ts` 파일이다. 이 스크립트는 node_modules 내의 각 React Native 라이브러리의 build.gradle 파일을 찾아서 namespace를 자동으로 추가해준다.

스크립트의 주요 기능은 다음과 같다:

- 라이브러리별 namespace 매핑 정보 관리
- @org/package 형태의 패키지도 처리 가능
- 이미 namespace가 있는 경우 건너뛰기
- 작업 진행 상황을 콘솔에 표시

### 결과

이제 `npm install`을 실행하면 자동으로 다음과 같은 작업이 진행된다:

1. 모든 패키지가 설치됨
2. postinstall 스크립트가 실행되어 필요한 라이브러리에 namespace가 추가됨
3. patch-package가 실행되어 수정된 내용이 패치로 저장됨

출력 결과를 보면 어떤 라이브러리에 namespace가 추가되었고, 어떤 것은 이미 namespace가 있어서 건너뛰었는지 확인할 수 있다.

## 마무리

이 자동화 작업으로 개발 환경 설정이 훨씬 수월해졌다. 새로운 팀원이 프로젝트를 셋업할 때도 별도의 수동 작업 없이 `npm install` 한 번으로 모든 설정이 완료된다.

React Native 프로젝트에서 이런 반복적인 작업들을 자동화하는 것은 매우 중요하다. 특히 팀 프로젝트에서는 더욱 그렇다. 이러한 자동화를 통해 개발자들은 본질적인 개발 작업에 더 집중할 수 있게 되었다.

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/044c89f8-6b69-4369-934d-15caa8a21a57/deb01970-5a31-48f9-a19b-77b251345c1e/image.png)