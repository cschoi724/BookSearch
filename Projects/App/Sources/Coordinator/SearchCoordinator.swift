//
//  SearchCoordinator.swift
//  App
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain
import BooksFeature

@MainActor
final class SearchCoordinator: SearchRouter, Router, ChildManaging {
    var children: [Router] = []
    private let navigator: Navigator
    private let di: AppDependency
    private weak var navController: UINavigationController?

    init(
        navigator: Navigator,
        di: AppDependency,
        navController: UINavigationController
    ) {
        self.navigator = navigator
        self.di = di
        self.navController = navController
    }

    func start() {
        let vc = SearchBuilder.make(
            router: self,
            searchBooks: di.container.resolve(SearchBooksUseCase.self)
        )
        navigator.setRoot(vc, animated: false)
    }

    func go(_ route: SearchRoute) {
        switch route {
        case .detail(let item):
            let child = DetailCoordinator(
                navigator: navigator,
                di: di,
                item: item
            )
            add(child)
            child.start()
        }
    }
}
