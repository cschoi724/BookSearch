//
//  SearchResult.swift
//  Domain
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public struct SearchResult: Equatable, Sendable {
    public let pageInfo: PageInfo
    public let books: [BookItem]

    public init(pageInfo: PageInfo, books: [BookItem]) {
        self.pageInfo = pageInfo
        self.books = books
    }
}
