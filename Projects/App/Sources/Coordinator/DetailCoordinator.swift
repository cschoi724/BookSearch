//
//  DetailCoordinator.swift
//  App
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import SafariServices
import Domain
import BooksFeature

@MainActor
final class DetailCoordinator: DetailRouter, Router, ChildManaging {
    var children: [Router] = []
    private let navigator: Navigator
    private let di: AppDependency
    private let item: BookItem

    init(navigator: Navigator, di: AppDependency, item: BookItem) {
        self.navigator = navigator
        self.di = di
        self.item = item
    }

    func start() {
        let vc = DetailBuilder.make(
            item: item,
            router: self,
            fetchBookDetail: di.container.resolve(FetchBookDetailUseCase.self)
        )
        navigator.push(vc, animated: true)
    }

    func go(_ route: DetailRoute) {
        switch route {
        case .openWeb(let url):
            let web = SafariFactory.make(url: url)
            Task { @MainActor in
                await navigator.present(web, animated: true)
            }
        }
    }
}

private enum SafariFactory {
    @MainActor
    static func make(url: URL) -> UIViewController {
        if #available(iOS 9.0, *) {
            return SFSafariViewController(url: url)
        } else {
            let vc = UIViewController()
            let web = UIWebView(frame: .zero)
            web.loadRequest(URLRequest(url: url))
            vc.view = web
            return vc
        }
    }
}
