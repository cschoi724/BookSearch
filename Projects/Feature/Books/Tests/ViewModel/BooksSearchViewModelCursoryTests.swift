//
//  BooksSearchViewModelCursoryTests.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import BooksFeature
import Domain

@MainActor
final class BooksSearchViewModelCursoryTests: XCTestCase {

    // 최초 검색 성공: 1페이지 교체
    func test_search_success_replacesPage1() async {
        let page1 = MockFactory.makeResult(page: 1, total: 25, count: 10)
        let stub = SearchBooksUseCaseStub()
        stub.set(page: 1, entry: (delayNS: 0, result: .success(page1)))

        let vm = BooksSearchViewModel(dependency: .init(searchBooksUseCase: stub))

        vm.send(.search("swift"))
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }
        
        XCTAssertEqual(vm.state.items.count, 10)
        XCTAssertEqual(vm.state.pageInfo.page, 1)
        XCTAssertEqual(vm.state.pageInfo.total, 25)
        XCTAssertNil(vm.state.errorMessage)
        XCTAssertFalse(vm.state.isLoading)
    }

    // 페이지네이션 성공: 2페이지 append
    func test_loadMore_appends_nextPage() async {
        let page1 = MockFactory.makeResult(page: 1, total: 25, count: 10)
        let page2 = MockFactory.makeResult(page: 2, total: 25, count: 10)

        let stub = SearchBooksUseCaseStub()
        stub.set(page: 1, entry: (delayNS: 0, result: .success(page1)))
        stub.set(page: 2, entry: (delayNS: 0, result: .success(page2)))

        let vm = BooksSearchViewModel(dependency: .init(searchBooksUseCase: stub))

        vm.send(.search("swift"))
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }
        vm.send(.loadMore)
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }


        XCTAssertEqual(vm.state.items.count, 20)
        XCTAssertEqual(vm.state.pageInfo.page, 2)
        XCTAssertEqual(vm.state.pageInfo.total, 25)
        XCTAssertNil(vm.state.errorMessage)
        XCTAssertFalse(vm.state.isLoading)
    }

    // 에러 발생 처리: errorMessage 설정 + 로딩 종료
    func test_search_failure_setsErrorMessage() async {
        enum DummyError: Error { case boom }

        let stub = SearchBooksUseCaseStub()
        stub.set(page: 1, entry: (delayNS: 0, result: .failure(DummyError.boom)))

        let vm = BooksSearchViewModel(dependency: .init(searchBooksUseCase: stub))

        vm.send(.search("swift"))
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        XCTAssertNotNil(vm.state.errorMessage)
        XCTAssertTrue(vm.state.items.isEmpty)
        XCTAssertFalse(vm.state.isLoading)
    }

    // 라우팅 상태: selectItem → route 설정, routeConsumed → nil
    func test_routing_state_set_and_consume() async {
        let page1 = MockFactory.makeResult(page: 1, total: 1, count: 1)
        let stub = SearchBooksUseCaseStub()
        stub.set(page: 1, entry: (delayNS: 0, result: .success(page1)))

        let vm = BooksSearchViewModel(dependency: .init(searchBooksUseCase: stub))

        vm.send(.search("swift"))
        await AsyncTestUtils.waitUntil { vm.state.isLoading == false }

        guard let first = vm.state.items.first else {
            return XCTFail("아이템이 비어있음")
        }

        vm.send(.selectItem(first))

        if case .detail(let got)? = vm.state.route {
            XCTAssertEqual(got.isbn13, first.isbn13)
        } else {
            XCTFail("route가 설정되지 않음")
        }

        vm.send(.routeConsumed)
        XCTAssertNil(vm.state.route)
    }
}
