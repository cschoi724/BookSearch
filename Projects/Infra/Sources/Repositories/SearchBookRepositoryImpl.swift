//
//  SearchBookRepositoryImpl.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public final class SearchBookRepositoryImpl: SearchBookRepository, @unchecked Sendable {
    
    private let remote: SearchBookRemoteDataSource

    public init(remote: SearchBookRemoteDataSource) {
        self.remote = remote
    }
    
    public func search(_ request: Domain.SearchRequest) async throws -> SearchResult {
        let response: ItBookSearchResponseDTO = try await remote.searchBooks(request)
        return response.toDomain()
    }
}
