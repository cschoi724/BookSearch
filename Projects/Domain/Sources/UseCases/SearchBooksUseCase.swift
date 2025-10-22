//
//  SearchBooksUseCase.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol SearchBooksUseCase {
    @discardableResult
    func callAsFunction(_ request: SearchRequest) async throws -> SearchResult
}

public struct DefaultSearchBooksUseCase: SearchBooksUseCase {
    private let repository: SearchRepository

    public init(repository: SearchRepository) {
        self.repository = repository
    }
    @discardableResult
    public func callAsFunction(_ request: SearchRequest) async throws -> SearchResult {
        try await repository.search(request)
    }
}
