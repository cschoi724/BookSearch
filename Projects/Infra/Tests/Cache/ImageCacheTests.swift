//
//  ImageCacheTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//


import XCTest
@testable import Infra

final class ImageCacheTests: XCTestCase {

    // 메모리 캐시에 데이터를 저장하고 다시 가져올 수 있다
    func test_memoryCache_storeAndFetch() async throws {
        let cache = MemoryImageCache()
        let url = URL(string: "https://itbook.store/img/books/image.png")!
        let data = Data("memory".utf8)

        await cache.store(data, for: url)
        let result = await cache.data(for: url)

        XCTAssertEqual(result, data)
    }

    // 메모리 캐시에서 데이터를 제거하면 nil을 반환한다
    func test_memoryCache_remove() async throws {
        let cache = MemoryImageCache()
        let url = URL(string: "https://itbook.store/img/books/image.png")!
        let data = Data("temp".utf8)

        await cache.store(data, for: url)
        await cache.remove(for: url)
        let result = await cache.data(for: url)

        XCTAssertNil(result)
    }

    // 디스크 캐시에 데이터를 저장하고 다시 불러올 수 있다
    func test_diskCache_storeAndFetch() async throws {
        let folder = "ImageCache-Test-\(UUID().uuidString)" // 테스트 간 폴더 격리
        let cache = DiskImageCache(cacheFolderName: folder)

        let url = URL(string: "https://itbook.store/img/books/disk.png")!
        let data = Data("disk".utf8)

        await cache.store(data, for: url)
        let result = await cache.data(for: url)

        XCTAssertEqual(result, data)

        await cache.removeAll() // 테스트 후 정리
    }

    // 디스크 캐시에서 데이터를 제거하면 nil을 반환한다
    func test_diskCache_remove() async throws {
        let folder = "ImageCache-Test-\(UUID().uuidString)"
        let cache = DiskImageCache(cacheFolderName: folder)

        let url = URL(string: "https://itbook.store/img/books/delete.png")!
        let data = Data("delete".utf8)

        await cache.store(data, for: url)
        await cache.remove(for: url)
        let result = await cache.data(for: url)

        XCTAssertNil(result)

        await cache.removeAll()
    }

    // 메모리 캐시에는 없지만 디스크 캐시에 존재하는 경우 디스크에서 읽고, 읽은 값을 메모리에 올린다
    func test_composedCache_readsFromDisk_whenMemoryMiss() async throws {
        let memory = MemoryImageCache()
        let folder = "ImageCache-Test-\(UUID().uuidString)"
        let disk = DiskImageCache(cacheFolderName: folder)
        let cache = ComposedImageCache(memory: memory, disk: disk)

        let url = URL(string: "https://itbook.store/img/books/composed.png")!
        let data = Data("composed".utf8)

        await disk.store(data, for: url) // 메모리에는 없음
        let result = await cache.data(for: url)

        XCTAssertEqual(result, data)

        // 디스크에 존재, 메모리에 올려 바로 가져올수있다.
        let memoryHit = await memory.data(for: url)
        XCTAssertEqual(memoryHit, data)

        await disk.removeAll()
    }
}
