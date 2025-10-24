//
//  AsyncTestUtils.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest

@MainActor
final class AsyncTestUtils {
    static func waitUntil(
        timeoutNS: UInt64 = 500_000_000,
        stepNS: UInt64 = 5_000_000,
        _ condition: @escaping () -> Bool
    ) async {
        var waited: UInt64 = 0
        while !condition() && waited < timeoutNS {
            try? await Task.sleep(nanoseconds: stepNS)
            waited += stepNS
        }
    }
}
