---
title: "Channel Talk 업데이트로 인한 Maven Repository 설정 이슈 해결하기"
date: 2024-12-05
categories: 
  - Troubleshooting
  - Development
tags:
  - React Native
  - Android
  - Channel Talk
  - Maven
  - Dependency Management
  - Gradle
  - Mobile Development
  - Technical Issue
---

# 문제 상황

최근 팀 프로젝트에서 흥미로운 이슈를 마주했다. 새로운 팀원이 `package.json`의 디펜던시를 업데이트하는 과정에서 Channel Talk 버전이 올라갔고, 그 이후부터 프로젝트 실행에 문제가 발생했다.

![image.png](/assets/img/posts/2024-12-05/2024-12-05-channel-talk-maven-repository-issue_2.png)


## 원인 파악

문제 해결을 위해 Channel Talk 공식 문서를 확인해보니, v0.9.0부터 설치 방법이 크게 변경되었다는 것을 발견했다. 특히 Maven repository 설정에 중요한 변화가 있었다.

주요 변경사항:

- Maven Central 지원이 2025년 8월 1일부터 중단될 예정이다.
- 새로운 maven repository([maven.channel.io](http://maven.channel.io/))를 사용해야 한다.

![image.png](/assets/img/posts/2024-12-05/2024-12-05-channel-talk-maven-repository-issue_3.png)

## 해결 과정

해결을 위해 `android/build.gradle` 파일을 수정해야 했다. 기존의 Maven Central 설정을 새로운 Channel Talk repository 설정으로 업데이트했다.

수정된 내용:

```
buildscript {
    repositories {
        google()
        mavenCentral()
        maven {
            url '<https://maven.channel.io/maven2>'
            name 'ChannelTalk'
        }
    }
}

allprojects {
    repositories {
        // 기존 repository 설정들...
        maven {
            url '<https://maven.channel.io/maven2>'
            name 'ChannelTalk'
        }
    }
}

```

![image.png](/assets/img/posts/2024-12-05/2024-12-05-channel-talk-maven-repository-issue_4.png)

`devrepo.kakao.com`을 참조하고 있는데, 이건 예전 저장소라 삭제했다.

## 결과

gradle 설정을 수정한 후, 다음 명령어로 빌드 캐시를 정리하고 프로젝트를 재실행했다:

```bash
cd android
./gradlew clean
cd ..
npm run android
```

이후 프로젝트가 정상적으로 실행되는 것을 확인할 수 있었다.

## 교훈

이번 이슈를 통해 몇 가지 중요한 점을 배웠다:

1. 디펜던시 업그레이드 시 해당 라이브러리의 메이저 버전 변경사항을 반드시 확인해야 한다.
2. 공식 문서를 꼼꼼히 확인하는 것이 문제 해결의 지름길이다.
3. Android 프로젝트에서 Maven repository 설정은 매우 중요한 부분이므로 신중하게 관리해야 한다.

## 참고 자료

- Channel Talk 공식 문서: https://developers.channel.io/docs
- React Native 설정 가이드: https://reactnative.dev/docs/environment-setup