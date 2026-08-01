# Market Island

나스닥 종합지수(`^IXIC`)와 USD/KRW 기준환율을 보여 주는 설치형 웹앱(PWA)입니다.

## 바로 사용하기

1. 이 프로젝트를 **Vercel**에 올립니다. 화면의 나스닥 시세는 Vercel의 안전한 데이터 중계 기능을 사용합니다.
2. 휴대폰에서 배포된 주소를 엽니다.
3. Android Chrome에서는 **설치**, iPhone Safari에서는 **공유 → 홈 화면에 추가**를 선택합니다.

로컬 파일을 직접 열면 PWA 설치와 오프라인 기능은 동작하지 않습니다. 반드시 `https` 또는 `localhost`에서 여세요.

## 데이터

- 나스닥: Yahoo Finance 공개 시세 응답 (Vercel Function을 통해 조회)
- USD/KRW: Frankfurter 기준환율 응답 (Vercel Function을 통해 조회)

두 제공처는 서비스 정책을 변경할 수 있습니다. 실서비스·상업적 용도라면 정식 금융 데이터 API로 교체하세요.
