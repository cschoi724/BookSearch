# BookSearch

도서 검색 및 상세 조회 iOS 애플리케이션 과제 프로젝트  
(itbook.store API 기반)

---

## 기술 스펙

- **언어**: Swift
- **UI 프레임워크**: UIKit
- **비동기 처리**: Swift Concurrency (async/await)
- **리액티브 바인딩**: Combine
- **아키텍처**: Clean Architecture + Modular Architecture
- **패턴**
  - MVVM (ViewModel + 단방향 상태 바인딩)
  - Coordinator (화면 전환 책임 분리)
  - Dependency Injection (직접 구현한 DIContainer)
- **빌드 시스템**: [Tuist](https://tuist.io)
- **테스트**: XCTest (Cursory Test 스타일)

---

## 프로젝트 구성

- **Domain**
  - Entities (BookItem, BookDetail, SearchResult, PageInfo …)
  - UseCases (SearchBooksUseCase, FetchBookDetailUseCase)
- **Feature**
  - Books
    - Search (검색 화면, 라우트/뷰모델/뷰/UI)
    - Detail (상세 화면, 라우트/뷰모델/뷰/UI)
    - DesignSystem (공용 UI/이미지 로딩)
- **App**
  - Coordinator (SearchCoordinator, DetailCoordinator, Navigator)
  - Dependency (AppDependency, DIContainer)
  - Application (SceneDelegate 등)

---

## 의존성 방향

- `App` → `Feature/Books` → `Domain`
- `Feature` 모듈은 `Domain`에만 의존
- `App`은 `Feature`, `Domain`을 조립
- **역방향 의존 없음** (Domain은 Feature, App을 모름)

---

## 설계 패턴 적용

- **MVVM**  
  - View ↔ ViewModel 단방향 상태 바인딩 (Combine)
  - ViewModel은 UseCase를 의존성으로 주입받아 데이터 처리
- **Coordinator**  
  - 화면 전환 및 흐름 제어 분리
  - SearchCoordinator → DetailCoordinator 흐름 관리
- **Dependency Injection**  
  - Swinject를 직접 사용하지 않고,DIContainer를 구현
  - `AppDependency`에서 의존성을 등록하고 주입
- **단방향 데이터 플로우**  
  - ViewModel이 State를 발행 → View가 반영
  - View의 이벤트는 Action으로 ViewModel에 전달

---

## 주요 기능

- **검색**
  - 상단 검색바에서 리턴키로 검색 실행
  - 결과를 테이블뷰로 표시 (썸네일 + 제목/서브타이틀/가격/ISBN/URL)
  - 검색 결과 0건일 때 EmptyView를 테이블뷰 배경으로 노출

- **페이지네이션 / 갱신**
  - 스크롤 말단 도달 시 다음 페이지 로드 (중복 요청 방지)
  - Pull-to-refresh로 목록 갱신

- **상세 화면**
  - BookDetail 전 필드 표시
  - PDF 목록 버튼 탭 시 Safari로 열기

- **이미지 로딩**
  - 메모리/디스크 캐시 + 동일 URL 동시 요청 머지로 중복 다운로드 방지

- **아키텍처/라우팅**
  - MVVM + 단방향 상태 바인딩(Combine)
  - Coordinator로 화면 전환 책임 분리 (검색 → 상세, 상세 → 웹)
  - DIContainer/AppDependency로 의존성 주입

- **상태/에러 처리**
  - 로딩/리프레시 상태 표시
  - 실패 시 사용자 피드백 및 안전한 재시도 흐름

---

## Tuist 및 개발 도구

### Tuist
- **프로젝트 생성**
  ```bash
  tuist init

    •    프로젝트 빌드/열기

tuist generate


    •    의존성 관리

tuist fetch



실행 방법

tuist generate
open BookSearch.xcworkspace


⸻



## License
All rights reserved.

---
