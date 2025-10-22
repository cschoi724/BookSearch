//
//  FetchBookDetailUseCase.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol FetchBookDetailUseCase {
    @discardableResult
    func callAsFunction(isbn13: String) async throws -> BookDetail
}

public struct DefaultFetchBookDetailUseCase: FetchBookDetailUseCase {
    private let repository: BookDetailRepository

    public init(repository: BookDetailRepository) {
        self.repository = repository
    }

    @discardableResult
    public func callAsFunction(isbn13: String) async throws -> BookDetail {
        try await repository.fetchBookDetail(isbn13: isbn13)
    }
}
