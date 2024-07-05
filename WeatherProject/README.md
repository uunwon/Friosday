# Weather
*˚☀️₊

## 개요
SwiftUI, Async/Await 를 이용해 날씨 앱 만들기 

### 목표
1. SwiftUI를 사용해 실제 날씨 정보 앱을 개발하기
2. WeatherKit을 사용해 실제 날씨 데이터를 가져오기
3. async/await를 활용해 비동기 작업을 효율적으로 처리하기
4. 사용자 인터페이스에 로딩 상태를 적절히 표시하기

### 폴더 구성
* WeatherData
  * Model, Codable 프로토콜 준수
* WeatherViewModel
  * ObservableObject 프로토콜 준수
  * @MainActor를 사용해 UI 업데이트 처리
* ContentView
  * @StateObject 를 사용해 ViewModel 관리

### 참고 사항
1. [WeatherKit 문서](https://drive.google.com/file/d/1CB7ZRHPcziY6mR7JnhV6pHf_a2WXyucZ/view)를 참고해 구현
2. WeatherKit 사용을 위해 공통 번들 아이디 필요
3. 위치 권한 요청 시 사용자 경험을 고려하여 구현
