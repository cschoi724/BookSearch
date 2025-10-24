//
//  MockItem.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import BooksFeature
@testable import Domain

enum MockFactory {
    static func makeBook(_ i: Int) -> BookItem {
        return BookItem(
            title: "Title \(i)",
            subtitle: "Sub \(i)",
            isbn13: "978000000\(1000 + i)",
            price: "$\(i)",
            image: "https://example.com/\(i).png",
            url: "https://example.com/\(i)"
        )
    }

    static func makeResult(page: Int, total: Int, count: Int) -> SearchResult {
        let books = (0..<count).map { makeBook(page * 100 + $0) }
        return SearchResult(
            pageInfo: PageInfo(page: page, total: total),
            books: books
        )
    }
}
