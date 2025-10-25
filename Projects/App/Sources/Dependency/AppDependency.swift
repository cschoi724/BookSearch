//
//  AppDependency.swift
//  App
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain
import Infra
import CoreKit
import BooksFeature

@MainActor
final class AppDependency {
    static let shared = AppDependency()

    private let container = DIContainer()

    private init() {
        register()
    }

    func makeBooksSearchRoot() -> UIViewController {
        let searchBooksUseCase = container.resolve(SearchBooksUseCase.self)
        let viewModel = BooksSearchViewModel(
            dependency: .init(searchBooksUseCase: searchBooksUseCase)
        )
        return BooksSearchViewController(viewModel: viewModel)
    }
}

private extension AppDependency {
    func register() {
        container
            .register(NetworkClient.self) { _ in
                DefaultNetworkClient()
            }
            .register(SearchBookRemoteDataSource.self) { r in
                SearchBookRemoteDataSourceImpl(
                    client: r.resolve(NetworkClient.self)
                )
            }
            .register(SearchBookRepository.self) { r in
                SearchBookRepositoryImpl(
                    remote: r.resolve(SearchBookRemoteDataSource.self)
                )
            }
            .register(SearchBooksUseCase.self) { r in
                let repo = r.resolve(SearchBookRepository.self)
                return DefaultSearchBooksUseCase(repository: repo)
            }
        
        
        container
            .register(ImageCache.self) { r in
                let mem = MemoryImageCache()
                let disk = DiskImageCache()
                return ComposedImageCache(memory: mem, disk: disk)
            }
            .register(ImageDataLoader.self) { r in
                let config = URLSessionConfiguration.default
                config.httpAdditionalHeaders = nil
                config.protocolClasses = nil
                config.requestCachePolicy = .returnCacheDataElseLoad
                config.waitsForConnectivity = true
                config.httpMaximumConnectionsPerHost = 4
                config.urlCache = URLCache(
                    memoryCapacity: 50 * 1024 * 1024,
                    diskCapacity: 300 * 1024 * 1024,
                    diskPath: "images-urlcache"
                )
                let imageSession = URLSession(configuration: config)
                return RemoteImageDataLoader(
                    cache: r.resolve(ImageCache.self),
                    session: imageSession
                )
            }
        
        let loader = container.resolve(ImageDataLoader.self)
        ImageDataSource.configure(loader: loader)

    }
}
