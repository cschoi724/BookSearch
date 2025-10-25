//
//  BooksDetailViewModelCursoryTests.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import BooksFeature
import Domain

@MainActor
final class BooksDetailViewModelCursoryTests: XCTestCase {

    // appear 시 상세 로드 성공
    func test_appear_loadsDetail_success() async {
        let item = MockFactory.makeBook(1)
        let expected = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/1")

        let stub = FetchBookDetailUseCaseStub()
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(expected)))

        let vm = BooksDetailViewModel(
            initialItem: item,
            dependency: .init(fetchBookDetail: stub)
        )

        vm.send(.appear)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        XCTAssertEqual(vm.state.detail?.isbn13, expected.isbn13)
        XCTAssertNil(vm.state.errorMessage)
        XCTAssertFalse(vm.state.isLoading)
    }

    // refresh 로 다시 로드되며 값이 갱신됨
    func test_refresh_triggersReload_andUpdatesDetail() async {
        let item = MockFactory.makeBook(2)
        let d1 = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/1")
        let d2 = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/2")

        let stub = FetchBookDetailUseCaseStub()
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(d1)))

        let vm = BooksDetailViewModel(initialItem: item, dependency: .init(fetchBookDetail: stub))

        // 1차 로드
        vm.send(.appear)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }
        XCTAssertEqual(vm.state.detail?.url, d1.url)

        // 2차 로드(응답 변경)
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(d2)))
        vm.send(.refresh)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        XCTAssertEqual(vm.state.detail?.url, d2.url)
    }

    // 에러 발생 시 errorMessage 설정 및 로딩 종료
    func test_error_setsErrorMessage_andStopsLoading() async {
        enum Dummy: Error { case boom }

        let item = MockFactory.makeBook(3)
        let stub = FetchBookDetailUseCaseStub()
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .failure(Dummy.boom)))

        let vm = BooksDetailViewModel(initialItem: item, dependency: .init(fetchBookDetail: stub))

        vm.send(.appear)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        XCTAssertNotNil(vm.state.errorMessage)
        XCTAssertNil(vm.state.detail)
        XCTAssertFalse(vm.state.isLoading)
    }

    // 라우팅: 상세 URL 우선, 그 다음 아이템 URL
    func test_openWebRouting_prefersDetailURL_overItemURL() async {
        let item = MockFactory.makeBook(4)
        let detail = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/url")
        let stub = FetchBookDetailUseCaseStub()
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(detail)))

        let vm = BooksDetailViewModel(initialItem: item, dependency: .init(fetchBookDetail: stub))

        vm.send(.appear)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }
        vm.send(.openWebTapped)

        switch vm.state.route {
        case .openWeb(let url):
            XCTAssertEqual(url.absoluteString, detail.url)
        case .none:
            XCTFail("route가 설정되어야 합니다.")
        }
    }

    // routeConsumed 시 라우팅 상태가 클리어됨
    func test_routeConsumed_clearsRoute() async {
        let item = MockFactory.makeBook(5)
        let detail = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/5")
        let stub = FetchBookDetailUseCaseStub()
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(detail)))

        let vm = BooksDetailViewModel(initialItem: item, dependency: .init(fetchBookDetail: stub))

        vm.send(.appear)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        vm.send(.openWebTapped)
        XCTAssertNotNil(vm.state.route)

        vm.send(.routeConsumed)
        XCTAssertNil(vm.state.route)
    }

    // 최신 요청 승리: 느린 첫 요청과 빠른 두 번째 요청이 겹칠 때 두 번째 결과가 반영
    func test_latestRequestWins_cancelsPrevious() async {
        let item = MockFactory.makeBook(6)

        let slow = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/slow")
        let fast = MockFactory.makeDetail(isbn13: item.isbn13, url: "https://detail/fast")

        let stub = FetchBookDetailUseCaseStub()
        // 느리게
        stub.set(isbn13: item.isbn13, entry: (delayNS: 250_000_000, result: .success(slow)))

        let vm = BooksDetailViewModel(initialItem: item, dependency: .init(fetchBookDetail: stub))

        // 첫 요청 시작
        vm.send(.appear)

        // 빠른 요청
        stub.set(isbn13: item.isbn13, entry: (delayNS: 0, result: .success(fast)))
        vm.send(.refresh)

        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        XCTAssertEqual(vm.state.detail?.url, fast.url, "최신 요청(fast)의 결과가 반영되어야 함")
    }
}
