//
//  SearchBookRemoteDataSourceStub.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import Infra
@testable import Domain

final class SearchBookRemoteDataSourceStub: SearchBookRemoteDataSource {
    enum StubError: Error { case notStubbed }

    var nextDTO: ItBookSearchResponseDTO?
    var nextError: Error?

    private(set) var lastRequest: SearchRequest?

    func searchBooks(_ request: SearchRequest) async throws -> ItBookSearchResponseDTO {
        lastRequest = request
        if let error = nextError { throw error }
        if let dto = nextDTO { return dto }
        throw StubError.notStubbed
    }
    
}
