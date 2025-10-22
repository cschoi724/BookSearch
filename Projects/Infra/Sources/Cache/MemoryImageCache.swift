//
//  MemoryImageCache.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public final class MemoryImageCache: ImageCache {
    private let cache = NSCache<NSURL, NSData>()

    public init(countLimit: Int = 200, totalCostLimit: Int = 50 * 1024 * 1024) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    public func data(for url: URL) async -> Data? {
        cache.object(forKey: url as NSURL) as Data?
    }

    public func store(_ data: Data, for url: URL) async {
        cache.setObject(data as NSData, forKey: url as NSURL, cost: data.count)
    }

    public func remove(for url: URL) async {
        cache.removeObject(forKey: url as NSURL)
    }

    public func removeAll() async {
        cache.removeAllObjects()
    }
}
