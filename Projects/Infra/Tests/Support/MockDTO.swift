//
//  MockDTO.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import Infra

enum MockDTO {
    nonisolated(unsafe) static let searchOK = ItBookSearchResponseDTO(
        error: "0",
        total: "20",
        page: "1",
        books: [
            ItBookBookItemDTO(
                title: "SwiftUI in Action",
                subtitle: "Build UIs",
                isbn13: "111",
                price: "$10",
                image: "img1",
                url: "u1"
            ),
            ItBookBookItemDTO(
                title: "Combine Essentials",
                subtitle: "FRP",
                isbn13: "222",
                price: "$12",
                image: "img2",
                url: "u2"
            )
        ]
    )

    nonisolated(unsafe) static let searchEmpty = ItBookSearchResponseDTO(
        error: "0",
        total: "0",
        page: "1",
        books: []
    )
    
    nonisolated(unsafe) static var detailOK: ItBookBookDetailDTO {        
        ItBookBookDetailDTO(
            error: "0",
            title: "Securing DevOps",
            subtitle: "Security in the Cloud",
            authors: "Julien Vehent",
            publisher: "Manning",
            language: "en",
            isbn10: "1617294136",
            isbn13: "9781617294136",
            pages: "384",
            year: "2018",
            rating: "5",
            desc: "desc",
            price: "$26.98",
            image: "https://itbook.store/img/books/9781617294136.png",
            url: "https://itbook.store/books/9781617294136",
            pdf: [
                "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
            ]
        )
    }
}
