# Market Island for iPhone

이 폴더는 iPhone의 **실제 Dynamic Island**에 나스닥과 USD/KRW를 표시하는 iOS 앱입니다.

## 설치

1. Mac에서 `MarketIsland.xcodeproj`를 Xcode로 엽니다.
2. 왼쪽에서 **MarketIsland** 앱 타깃을 선택하고 **Signing & Capabilities**에서 본인 Apple ID의 Team을 선택합니다.
3. `com.vibeonetool.marketisland` 번들 ID가 이미 사용 중이면 고유한 값으로 변경합니다. 위젯 타깃 번들 ID도 같은 접두사로 맞춥니다.
4. iPhone 16을 USB로 연결하고 Xcode 상단의 실행 기기로 선택한 뒤 ▶ 버튼을 누릅니다.
5. 앱에서 **다이나믹 아일랜드 시작**을 누른 다음 홈 화면으로 나가면 실제 다이나믹 아일랜드에 축약 시세가 표시됩니다. 길게 누르면 확장 시세를 볼 수 있습니다.

## 동작 방식

- 앱은 시작·새로고침할 때 배포된 시장 데이터 API에서 나스닥 종합지수와 USD/KRW를 가져옵니다.
- iOS Live Activity는 시스템 기능이므로 화면 최상단에 항상 고정하거나 무기한 실행할 수 없습니다. 한 활동은 최대 8시간 동안만 유지됩니다.
- 앱이 백그라운드에 있는 동안에도 시세를 계속 갱신하려면 Apple Developer 계정, APNs 인증키, 그리고 ActivityKit 푸시 서버가 추가로 필요합니다. 현재 버전은 시작 시점의 시세를 실제 Dynamic Island에 표시하고, 앱을 열어 **새로고침**하면 업데이트합니다.
