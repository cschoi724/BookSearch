//
//  ThreadSafe.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

final class Counter: @unchecked Sendable {
    private let queue = DispatchQueue(label: "counter.queue")
    private var n = 0
    func increment() { queue.sync { n += 1 } }
    func value() -> Int { queue.sync { n } }
}


final class CallFlag: @unchecked Sendable {
    private let queue = DispatchQueue(label: "flag.queue")
    private var value = false

    func set() {
        queue.sync { value = true }
    }

    func get() -> Bool {
        queue.sync { value }
    }
}
