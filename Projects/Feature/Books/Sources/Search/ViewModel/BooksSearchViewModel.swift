//
//  BooksSearchViewModel.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

@MainActor
public final class BooksSearchViewModel {

    public struct Dependency {
        public let searchBooksUseCase: SearchBooksUseCase
        
        public init(searchBooksUseCase: SearchBooksUseCase) {
            self.searchBooksUseCase = searchBooksUseCase
        }
    }

    enum Route {
        case detail(BookItem)
    }

    struct State {
        var query: String = ""
        var items: [BookItem] = []
        var pageInfo: PageInfo = .init(page: 1, total: 0)
        var isLoading: Bool = false
        var errorMessage: String?
        var route: Route? = nil
    }

    enum Action {
        case search(String)
        case loadMore
        case selectItem(BookItem)
        case routeConsumed
        case didLoad(Result<SearchResult, Error>, requestedPage: Int)
    }

    @Published private(set) var state = State()

    private let dependency: Dependency
    private var loadTask: Task<Void, Never>?
    private var requestToken = 0
    
    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    deinit {
        loadTask?.cancel()
    }

    func send(_ action: Action) {
        reduce(action)
    }

    private func reduce(_ action: Action) {
        switch action {

        case .search(let text):
            let q = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !q.isEmpty else { return }
            state.query = q
            state.items = []
            state.pageInfo = .init(page: 1, total: 0)
            guard state.isLoading == false else { return }
            state.isLoading = true
            request(page: 1)

        case .loadMore:
            guard state.isLoading == false,
                  state.pageInfo.hasNext(itemsLoaded: state.items.count) else {
                return
            }
            state.isLoading = true
            request(page: state.pageInfo.nextPage)
            
        case .selectItem(let item):
            state.route = .detail(item)
            
        case .routeConsumed:
            state.route = nil
            
        case .didLoad(let result, let requestedPage):
            state.isLoading = false
            switch result {
            case .success(let res):
                if requestedPage == 1 {
                    state.items = res.books
                } else {
                    state.items.append(contentsOf: res.books)
                }
                state.pageInfo = res.pageInfo
                state.errorMessage = nil

            case .failure(let err):
                state.errorMessage = err.localizedDescription
            }
        }
    }

    private func request(page: Int) {
        loadTask?.cancel()
        requestToken &+= 1
        let token = requestToken
        let query = state.query
        let useCase = dependency.searchBooksUseCase

        loadTask = Task { [weak self] in
            guard let self else { return }
            let req = SearchRequest(query: query, page: page)
            do {
                let result = try await useCase(req)
                await MainActor.run {
                    guard token == self.requestToken else { return }
                    self.send(.didLoad(.success(result), requestedPage: page))
                }
            } catch {
                await MainActor.run {
                    guard token == self.requestToken else { return }
                    self.send(.didLoad(.failure(error), requestedPage: page))
                }
            }
        }
    }
}

extension PageInfo {
    var nextPage: Int { page + 1 }
    
    func hasNext(itemsLoaded: Int) -> Bool {
        itemsLoaded < total
    }
}
