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
    private let repository: DetailRepository

    public init(repository: DetailRepository) {
        self.repository = repository
    }

    @discardableResult
    public func callAsFunction(isbn13: String) async throws -> BookDetail {
        try await repository.fetchDetail(isbn13: isbn13)
    }
}
