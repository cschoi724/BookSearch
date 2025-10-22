//
//  DiskImageCache.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import CryptoKit

public final class DiskImageCache: ImageCache {
    private let root: URL
    private let fileManager: FileManager
    private let maxAge: TimeInterval

    public init(
        cacheFolderName: String = "ImageCache",
        maxAge: TimeInterval = 7 * 24 * 60 * 60,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.maxAge = maxAge
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.root = caches.appendingPathComponent(cacheFolderName, isDirectory: true)
        try? fileManager.createDirectory(at: root, withIntermediateDirectories: true)
    }

    public func data(for url: URL) async -> Data? {
        let path = pathFor(url)
        guard fileManager.fileExists(atPath: path.path) else { return nil }

        if let attrs = try? fileManager.attributesOfItem(atPath: path.path),
           let mdate = attrs[.modificationDate] as? Date {
            if Date().timeIntervalSince(mdate) > maxAge {
                try? fileManager.removeItem(at: path)
                return nil
            }
        }

        return try? Data(contentsOf: path)
    }

    public func store(_ data: Data, for url: URL) async {
        let path = pathFor(url)
        do {
            try data.write(to: path, options: [.atomic])
            try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: path.path)
        } catch { }
    }

    public func remove(for url: URL) async {
        let path = pathFor(url)
        try? fileManager.removeItem(at: path)
    }

    public func removeAll() async {
        try? fileManager.removeItem(at: root)
        try? fileManager.createDirectory(at: root, withIntermediateDirectories: true)
    }

    private func pathFor(_ url: URL) -> URL {
        let key = sha256(url.absoluteString)
        return root.appendingPathComponent(key, isDirectory: false)
    }

    private func sha256(_ s: String) -> String {
        let hash = SHA256.hash(data: Data(s.utf8))
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
