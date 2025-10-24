//
//  PageInfo.swift
//  Domain
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public struct PageInfo: Equatable, Sendable {
    public let page: Int
    public let total: Int

    public init(page: Int, total: Int) {
        self.page = page
        self.total = total
    }
}
