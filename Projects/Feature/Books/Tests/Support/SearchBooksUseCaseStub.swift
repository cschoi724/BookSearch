//
//  SearchBooksUseCaseStub.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

@testable import BooksFeature
import Domain

final class SearchBooksUseCaseStub: SearchBooksUseCase {
    typealias Page = Int
    typealias SearchResponse = Result<SearchResult, Error>
    typealias ResponseEntry = (delayNS: UInt64, result: SearchResponse)

    var responses: [Page: ResponseEntry] = [:]

    init(responses: [Page: ResponseEntry] = [:]) {
        self.responses = responses
    }

    func set(page: Page, entry: ResponseEntry) {
        responses[page] = entry
    }

    func callAsFunction(_ request: SearchRequest) async throws -> SearchResult {
        let defaultResponseEntry: ResponseEntry = (
            0,
            .success(
                SearchResult(
                    pageInfo: .init(page: request.page, total: 0),
                    books: []
                )
            )
            
        )
        let entry = responses[request.page] ?? defaultResponseEntry

        if entry.delayNS > 0 {
            try? await Task.sleep(nanoseconds: entry.delayNS)
        }
        switch entry.result {
        case .success(let res):
            return res
        case .failure(let err):
            throw err
        }
    }
}
