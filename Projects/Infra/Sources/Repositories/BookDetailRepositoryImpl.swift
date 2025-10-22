//
//  BookDetailRepositoryImpl.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public final class BookDetailRepositoryImpl: BookDetailRepository, @unchecked Sendable {
    
    private let remote: BookDetailRemoteDataSource

    public init(remote: BookDetailRemoteDataSource) {
        self.remote = remote
    }
    
    public func fetchBookDetail(isbn13: String) async throws -> BookDetail {
        let response: ItBookBookDetailDTO = try await remote.fetchBookDetail(isbn13)
        return response.toDomain()
    }
}
