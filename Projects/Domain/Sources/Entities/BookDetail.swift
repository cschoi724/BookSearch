//
//  BookDetail.swift
//  Domain
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public struct BookDetail: Equatable {
    public let title: String
    public let subtitle: String?
    public let authors: String?
    public let publisher: String?
    public let language: String?
    public let isbn10: String?
    public let isbn13: String
    public let pages: Int?
    public let year: String?
    public let rating: Int?
    public let desc: String?

    public let price: String
    public let image: String?
    public let url: String?
    public let pdfs: [PDFItem]

    public init(
        title: String,
        subtitle: String?,
        authors: String?,
        publisher: String?,
        language: String?,
        isbn10: String?,
        isbn13: String,
        pages: Int?,
        year: String?,
        rating: Int?,
        desc: String?,
        price: String,
        image: String?,
        url: String?,
        pdfs: [PDFItem]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publisher = publisher
        self.language = language
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.price = price
        self.image = image
        self.url = url
        self.pdfs = pdfs
    }
}
