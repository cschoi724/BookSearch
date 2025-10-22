//
//  RemoteImageDataLoader.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import CoreKit

public enum ImageLoaderError: Error {
    case invalidResponse
    case invalidStatus(Int)
}

public final class RemoteImageDataLoader: ImageDataLoader {
    private let cache: ImageCache
    private let session: URLSession
    private let inFlight = InFlightRequests()

    public init(cache: ImageCache, session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }

    public func load(from url: URL) async throws -> Data {
        if let cached = await cache.data(for: url) {
            return cached
        }

        if await inFlight.begin(url) == false {
            return try await inFlight.wait(url)
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse else {
                throw ImageLoaderError.invalidResponse
            }
            guard (200..<300).contains(http.statusCode) else {
                throw ImageLoaderError.invalidStatus(http.statusCode)
            }

            await cache.store(data, for: url)
            await inFlight.finish(url, result: .success(data))
            return data
        } catch {
            await inFlight.finish(url, result: .failure(error))
            throw error
        }
    }
}
