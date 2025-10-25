//
//  BooksDetailViewModel.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

@MainActor
public final class BooksDetailViewModel {

    public struct Dependency {
        public let fetchBookDetail: FetchBookDetailUseCase

        public init(fetchBookDetail: FetchBookDetailUseCase) {
            self.fetchBookDetail = fetchBookDetail
        }
    }

    enum Route {
        case openWeb(URL)
    }

    struct State {
        var item: BookItem
        var detail: BookDetail? = nil
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var route: Route? = nil
    }

    enum Action {
        case appear
        case refresh
        case openWebTapped
        case routeConsumed
        case didLoad(Result<BookDetail, Error>)
    }

    @Published private(set) var state: State

    private let dependency: Dependency
    private var loadTask: Task<Void, Never>?
    private var requestToken = 0

    public init(initialItem: BookItem, dependency: Dependency) {
        self.state = .init(item: initialItem)
        self.dependency = dependency
    }

    deinit { loadTask?.cancel() }

    func send(_ action: Action) {
        reduce(action)
    }

    private func reduce(_ action: Action) {
        switch action {
        case .appear:
            guard state.detail == nil, state.isLoading == false else { return }
            state.isLoading = true
            request()

        case .refresh:
            guard state.isLoading == false else { return }
            state.isLoading = true
            request()

        case .openWebTapped:
            if let urlStr = state.detail?.url ?? state.item.url,
               let url = URL(string: urlStr) {
                state.route = .openWeb(url)
            }

        case .routeConsumed:
            state.route = nil

        case .didLoad(let result):
            state.isLoading = false
            switch result {
            case .success(let detail):
                state.detail = detail
                state.errorMessage = nil
            case .failure(let error):
                state.errorMessage = error.localizedDescription
            }
        }
    }

    private func request() {
        loadTask?.cancel()
        requestToken &+= 1
        let token = requestToken
        let isbn = state.item.isbn13
        let useCase = dependency.fetchBookDetail

        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let detail = try await useCase(isbn13: isbn)
                guard token == self.requestToken else { return }
                self.send(.didLoad(.success(detail)))
            } catch {
                guard token == self.requestToken else { return }
                self.send(.didLoad(.failure(error)))
            }
        }
    }
}
