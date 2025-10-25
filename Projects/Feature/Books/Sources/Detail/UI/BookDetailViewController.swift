//
//  BookDetailViewController.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Combine
import Domain

public final class BooksDetailViewController: UIViewController {
    private let router: DetailRouter
    private let viewModel: BooksDetailViewModel
    private let rootView = BooksDetailView()
    private var bag = Set<AnyCancellable>()

    public init(viewModel: BooksDetailViewModel, router: DetailRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func loadView() {
        self.view = rootView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "도서 상세"
        setupActions()
        bindViewModel()
        viewModel.send(.appear)

    }
}

private extension BooksDetailViewController {
    func setupActions() {
        rootView.refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        rootView.onPDFTapped = { [weak self] url in
            self?.handle(route: .openWeb(url))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "웹으로 보기",
            style: .plain,
            target: self,
            action: #selector(onOpenWeb)
        )
    }

    func bindViewModel() {
        let state = viewModel.$state
            .receive(on: RunLoop.main)
            .share()

        state
            .sink { [weak self] s in
                guard let self else { return }
                self.rootView.configure(item: s.item, detail: s.detail)
                if !s.isLoading {
                    self.rootView.refresh.endRefreshing()
                }
            }
            .store(in: &bag)

        state
            .compactMap(\.route)
            .sink { [weak self] route in
                guard let self else { return }
                self.handle(route: route)
                self.viewModel.send(.routeConsumed)
            }
            .store(in: &bag)

        state
            .compactMap(\.errorMessage)
            .removeDuplicates()
            .sink { msg in
                print("Detail Error:", msg)
            }
            .store(in: &bag)
    }
}

private extension BooksDetailViewController {
    @objc func onRefresh() {
        viewModel.send(.refresh)
    }

    @objc func onOpenWeb() {
        viewModel.send(.openWebTapped)
    }

    func handle(route: BooksDetailViewModel.Route) {
        switch route {
        case .openWeb(let url):
            self.router.go(.openWeb(url: url))
        }
    }
}
