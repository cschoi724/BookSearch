//
//  MockRepository.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import Domain

final class MockSearchBookRepository: SearchBookRepository {
    var lastQuery: SearchRequest?
    var result: SearchResult?
    var error: Error?

    func search(_ request: SearchRequest) async throws -> SearchResult {
        lastQuery = request

        if let error {
            throw error
        }

        guard let result else {
            throw NSError(domain: "MockSearchBookRepository", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "No mock result set"
            ])
        }

        return result
    }
}

final class MockBookDetailRepository: BookDetailRepository {
    var lastISBN: String?
    var result: BookDetail?
    var error: Error?

    func fetchBookDetail(isbn13: String) async throws -> BookDetail {
        lastISBN = isbn13

        if let error {
            throw error
        }

        guard let result else {
            throw NSError(
                domain: "MockBookDetailRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "No mock result set"
                ]
            )
        }

        return result
    }
}
