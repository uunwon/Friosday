# ToDoList
📜 . ˚⁎ ◌ ｡ﾟ⊹

## 개요
UIKit 를 이용해 메모 앱 만들기

### 기본 요구사항
1. 할 일 목록보기: 테이블 뷰 사용
2. 할 일 추가하기: 모달 창 혹은 별도의 화면을 통해 제공
3. 할 일 삭제하기: 스와이프, 편집 모드로 삭제 가능
4. 할 일 완료 상태 변경: 체크박스 혹은 토글 버튼 사용

### 추가 요구사항
* 데이터 저장
  * 목록은 앱을 종료하고 다시 실행해도 유지
  * UserDefaults 사용해 데이터 로컬에 저장
* 기본 UI 디자인
  * UIKit 컴포넌트 사용해 직관적이고 간단한 UI 제공
  * Auto Layout 사용해 다양한 화면 크기에 대응

### 예시 UI 흐름
1. 메인 화면
   - Navigation Bar: "ToDo List" 타이틀, '추가' 버튼
   - Table View: 할 일 목록 표시
2. 할 일 추가 화면
   - Navigation Bar: "Add ToDo" 타이틀, '취소' 및 '저장' 버튼
   - Text Field: 할 일 제목 입력
3. 할 일 목록
   - 각 셀에는 할 일 제목과 완료 상태를 표시하는 체크박스 (또는 토글 버튼)
   - 스와이프하여 삭제 가능

### 기술 스택
* UIKit
* UITableView, UITableViewCell
* UIButton, UITextField
* UserDefaults
* Auto Layout
