//
//  SearchBookRepository.swift
//  Domain
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol SearchRepository {
    func search(_ request: SearchRequest) async throws -> SearchResult
}
