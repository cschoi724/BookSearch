//
//  FetchBookDetailUseCaseStub.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

@testable import BooksFeature
@testable import Domain
import Foundation

final class FetchBookDetailUseCaseStub: FetchBookDetailUseCase {
    typealias Key = String
    typealias DetailResponse = Result<BookDetail, Error>
    typealias ResponseEntry = (delayNS: UInt64, result: DetailResponse)

    var responses: [Key: ResponseEntry] = [:]

    init(responses: [Key: ResponseEntry] = [:]) {
        self.responses = responses
    }

    func set(isbn13: Key, entry: ResponseEntry) {
        responses[isbn13] = entry
    }

    // MARK: UseCase
    func callAsFunction(isbn13: String) async throws -> BookDetail {
        let defaultEntry: ResponseEntry = (
            0,
            .success(
                BookDetail(
                    title: "T",
                    subtitle: "S",
                    authors: "AU",
                    publisher: "PB",
                    language: "EN",
                    isbn10: "0000000000",
                    isbn13: isbn13,
                    pages: 0,
                    year: "2024",
                    rating: 0,
                    desc: "DESC",
                    price: "$0",
                    image: "https://example.com/\(isbn13).png",
                    url: "https://example.com/\(isbn13)",
                    pdfs: []
                )
            )
        )

        let entry = responses[isbn13] ?? defaultEntry

        if entry.delayNS > 0 {
            try? await Task.sleep(nanoseconds: entry.delayNS)
        }

        switch entry.result {
        case .success(let detail):
            return detail
        case .failure(let error):
            throw error
        }
    }
}
