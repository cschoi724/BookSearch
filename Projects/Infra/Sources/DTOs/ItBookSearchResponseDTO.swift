//
//  ItBookSearchResponseDTO.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public struct ItBookSearchResponseDTO: Decodable {
    let error: String
    let total: String
    let page: String
    let books: [ItBookBookItemDTO]
}

public extension ItBookSearchResponseDTO {
    func toDomain() -> SearchResult {
        SearchResult(
            pageInfo: PageInfo(
                page: Int(page) ?? 1,
                total: Int(total) ?? 0
            ),
            books: books.map { $0.toDomain() }
        )
    }
}
