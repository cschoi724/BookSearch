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
    
    static func makeDetail(isbn13: String, url: String) -> BookDetail {
        return BookDetail(
            title: "Sample Title",
            subtitle: "Sample Subtitle",
            authors: "Author One, Author Two",
            publisher: "Sample Publisher",
            language: "English",
            isbn10: "1234567890",
            isbn13: isbn13,
            pages: 350,
            year: "2025",
            rating: 5,
            desc: "This is a sample description of the book.",
            price: "$20",
            image: "https://example.com/sample.png",
            url: url,
            pdfs: [PDFItem(name: "chapter1", url: "https://example.com/chapter1.pdf")]
        )
    }
}
