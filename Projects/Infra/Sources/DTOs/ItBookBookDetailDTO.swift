//
//  ItBookBookDetailDTO.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public struct ItBookBookDetailDTO: Decodable {
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String?
    let isbn10: String?
    let isbn13: String
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    let price: String
    let image: String
    let url: String
    let pdf: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case error, title, subtitle, authors, publisher, language, isbn10, isbn13,
             pages, year, rating, desc, price, image, url, pdf
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decode(String.self, forKey: .error)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
        authors = try container.decodeIfPresent(String.self, forKey: .authors) ?? ""
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher) ?? ""
        language = try container.decodeIfPresent(String.self, forKey: .language)
        isbn10 = try container.decodeIfPresent(String.self, forKey: .isbn10)
        isbn13 = try container.decode(String.self, forKey: .isbn13)
        pages = try container.decodeIfPresent(String.self, forKey: .pages)
        year = try container.decodeIfPresent(String.self, forKey: .year)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        pdf = try container.decodeIfPresent([String: String].self, forKey: .pdf)
    }
    
    init(error: String, title: String, subtitle: String, authors: String, publisher: String, language: String?, isbn10: String?, isbn13: String, pages: String?, year: String?, rating: String?, desc: String?, price: String, image: String, url: String, pdf: [String : String]?) {
        self.error = error
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
        self.pdf = pdf
    }
}

public extension ItBookBookDetailDTO {
    func toDomain() -> BookDetail {
        BookDetail(
            title: title,
            subtitle: subtitle.isEmpty ? nil : subtitle,
            authors: authors.isEmpty ? nil : authors,
            publisher: publisher.isEmpty ? nil : publisher,
            language: language,
            isbn10: isbn10,
            isbn13: isbn13,
            pages: Int(pages ?? ""),
            year: year,
            rating: Int(rating ?? ""),
            desc: desc,
            price: price,
            image: image,
            url: url,
            pdfs: (pdf ?? [:]).map { PDFItem(name: $0.key, url: $0.value) }
        )
    }
}
