# GA4와 GTM 적용기: 웹뷰 프로젝트의 사용자 분석하기

## 배경

최근 회사에서 흥미로운 협업 프로젝트를 진행했다. 우리 팀이 개발한 웹 애플리케이션이 파트너사의 네이티브 앱 내 웹뷰로 서비스되는 구조였다. 이 프로젝트는 자동차 구매 플랫폼으로, 사용자가 차량 견적을 내고 신차 상담을 신청할 수 있는 서비스다.

프로젝트가 오픈되고 나서 가장 큰 고민은 "실제로 얼마나 많은 사용자가 우리 서비스를 이용하고 있을까?"였다. 특히 웹뷰 환경이다 보니 일반적인 웹사이트보다 사용자 행동 패턴을 파악하기가 더 까다로웠다. 이 문제를 해결하기 위해 Google Analytics 4(GA4)와 Google Tag Manager(GTM)를 도입하게 됐다.

## 기술 스택 선정

React 프로젝트에 GA4를 적용하기 위해 다음과 같은 도구들을 선택했다:

- react-ga: Google Analytics와 React를 연동하기 위한 라이브러리
- react-gtm-module: Google Tag Manager 설정을 위한 라이브러리
- react-router-dom: 라우팅 기반 페이지뷰 추적을 위해 사용

## 구현 과정

### 1. Google Analytics 속성 및 데이터 스트림 설정

먼저 Google Analytics에서 데이터를 수집하기 위한 기본 설정을 했다:

1. Google Analytics([analytics.google.com](https://analytics.google.com/))에 접속하여 로그인

2. 관리 > 만들기 > 속성 클릭
![관리 > 만들기 > 속성 클릭](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_1.png)

3. 속성 설정:
    - 속성 이름(필수): [속성 이름]
    - 보고 시간대: "대한민국"
    - 통화: "KRW-한국 원"
![속성 설정](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_3.png)

4. 비즈니스 세부정보 입력:
![비즈니스 세부정보 입력](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_4.png)

5. 플랫폼 선택:
![플랫폼 선택](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_5.png)

6. 웹사이트 URL 정보 입력:
![웹사이트 URL 정보 입력](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_6.png)

7. `index.html`의 `<head></head>`안에 아래 코드를 복사해서 삽입:
![`index.html`의 `<head></head>`안에 아래 코드를 복사해서 삽입](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_7.png)


데이터 스트림을 생성하면 "측정 ID(G-로 시작하는 ID)"가 발급된다. 이 ID는 GA4 구현에 필요한 핵심 정보다.

### 2. 환경 변수 설정

먼저 개발 환경과 프로덕션 환경에서 각각 다른 GA4 추적 ID를 사용할 수 있도록 환경 변수를 설정했다:

```
VITE_GA_TRACKING_ID=G-98CRVRP3CW
VITE_GTM_ID=GTM-MM88PWSZ
```

### 3. TypeScript 환경 설정

Vite와 TypeScript를 사용하는 환경에서는 환경 변수 타입을 정의해야 한다. 이를 위해 `vite-env.d.ts` 파일에 다음과 같은 타입 정의를 추가했다:

```tsx
/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_GTM_ID: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
```

### 4. Google Analytics와 GTM 초기 설정

index.html에 GA4와 GTM 스크립트를 모두 추가했다. GA4는 gtag.js를 통해 설정하고, GTM은 별도의 스크립트를 추가했다:

```html
<!-- Google tag (gtag.js) -->
<script async src="<https://www.googletagmanager.com/gtag/js?id=[측정 ID]>"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag('js', new Date());
  gtag('config', '[측정 ID]');
</script>


```

또한 noscript 태그를 사용해 JavaScript가 비활성화된 환경에서도 GTM이 동작할 수 있도록 했다:

```html

<!-- Google Tag Manager -->
<!-- head 태그안에 추가 -->
<script>
  (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  '<https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f)>;
  })(window,document,'script','dataLayer','[측정 ID]');
</script>


<!-- Google Tag Manager (noscript) -->
<!-- 닫는 body 태그 바로 위 추가 -->
<noscript>
  <iframe src="<https://www.googletagmanager.com/ns.html?id=[측정 ID]>"
    height="0" width="0" style="display:none;visibility:hidden">
  </iframe>
</noscript>
```

### 5. React 애플리케이션에서의 초기화

애플리케이션의 진입점인 main.tsx에서 GA4와 GTM을 초기화했다:

```typescript
// GA 초기화
const gaTrackingId = import.meta.env.VITE_GA_TRACKING_ID;
ReactGA.initialize(gaTrackingId);

// 히스토리 설정으로 페이지 추적
const history = createBrowserHistory();
history.listen((response) => {
  ReactGA.set({ page: response.location.pathname });
  ReactGA.pageview(response.location.pathname);
});
```

### 6. 이벤트 트래킹 구현

특히 중요했던 것은 상담 신청 버튼 클릭 이벤트의 추적이었다. GTM에서 태그와 트리거를 만들었다.

- 태그
![태그](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_8.png)

- 트리거
![트리거](/assets/img/posts/2024-12-04/ga4-gtm-integration-for-webview-project_9.png)
여기서 보이는 트리거의 이름이 아래 유틸리티 함수의 event명이 된다.

그리고 이 트리거를 위한 별도의 유틸리티 함수를 만들어 관리했다:

```tsx
export const sendGAEvent = () => {
  TagManager.dataLayer({
    dataLayer: {
      event: 'click_counseling_request',
      event_category: 'Engagement',
      event_label: '즉시 상담신청',
    },
  });
};
```

## Google Analytics 보고서 설정

GA4 설정이 완료되면 Google Analytics 보고서 페이지에서 다양한 데이터를 확인할 수 있다. 주요 보고서 설정은 다음과 같이 했다:

1. 실시간 보고서:
    - 현재 활성 사용자 수 모니터링
    - 많이 조회되는 페이지 추적
    - 사용자 위치 데이터 수집
2. 수명주기 보고서:
    - 사용자 획득 데이터
    - 참여도 분석
    - 수익 창출 지표
    - 유지 관련 지표
3. 사용자 속성:
    - 신규/재방문 사용자 구분
    - 기기 유형별 사용자 분포
    - 지역별 사용자 분포

## 결과 및 인사이트

GA4와 GTM 설정을 완료한 후, 다음과 같은 실제 데이터를 수집할 수 있게 됐다:

1. 일별 실제 사용자 수
2. 페이지별 체류 시간
3. 상담 신청 전환율
4. 사용자 이탈률  
 
이러한 데이터를 통해 몇 가지 중요한 인사이트를 얻을 수 있었다:

- 웹뷰를 통한 실제 서비스 사용자가 존재한다는 것을 확인
- 상담 신청 프로세스에서의 사용자 행동 패턴 파악
- 개선이 필요한 페이지와 기능 식별

## 마치며

GA4와 GTM의 도입으로 "데이터에 기반한 의사결정"이 가능해졌다. 특히 웹뷰 환경에서의 사용자 행동을 추적하고 분석할 수 있게 된 것은 큰 성과였다. 이러한 데이터는 앞으로의 서비스 개선과 사용자 경험 최적화에 큰 도움이 될 것으로 기대된다.