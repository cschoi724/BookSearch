//
//  BookDetailRemoteDataSourceStub.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import Infra
@testable import Domain

final class BookDetailRemoteDataSourceStub: BookDetailRemoteDataSource {
    
    enum StubError: Error { case notStubbed }

    var nextDTO: ItBookBookDetailDTO?
    var nextError: Error?

    private(set) var last_isbn13: String?

    func fetchBookDetail(_ isbn13: String) async throws -> ItBookBookDetailDTO {
        self.last_isbn13 = isbn13
        if let error = nextError { throw error }
        if let dto = nextDTO { return dto }
        throw StubError.notStubbed
    }
}
