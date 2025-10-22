//
//  ImageCache.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol ImageCache {
    func data(for url: URL) async -> Data?
    func store(_ data: Data, for url: URL) async
    func remove(for url: URL) async
    func removeAll() async
}

public struct ComposedImageCache: ImageCache {
    private let memory: ImageCache
    private let disk: ImageCache

    public init(memory: ImageCache, disk: ImageCache) {
        self.memory = memory
        self.disk = disk
    }

    public func data(for url: URL) async -> Data? {
        if let d = await memory.data(for: url) { return d }
        if let d = await disk.data(for: url) {
            await memory.store(d, for: url)
            return d
        }
        return nil
    }

    public func store(_ data: Data, for url: URL) async {
        await memory.store(data, for: url)
        await disk.store(data, for: url)
    }

    public func remove(for url: URL) async {
        await memory.remove(for: url)
        await disk.remove(for: url)
    }

    public func removeAll() async {
        await memory.removeAll()
        await disk.removeAll()
    }
}
