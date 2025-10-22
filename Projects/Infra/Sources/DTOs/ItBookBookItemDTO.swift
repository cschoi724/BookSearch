//
//  ItBookBookItemDTO.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public struct ItBookBookItemDTO: Decodable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}

public extension ItBookBookItemDTO {
    func toDomain() -> BookItem {
        BookItem(
            title: title,
            subtitle: subtitle,
            isbn13: isbn13,
            price: price,
            image: image,
            url: url
        )
    }
}
