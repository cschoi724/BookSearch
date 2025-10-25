//
//  BooksSearchViewController.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Combine
import Domain
import CoreKit

public final class BooksSearchViewController: UIViewController {
    private let viewModel: BooksSearchViewModel
    private let rootView = BooksSearchView()
    private var bag = Set<AnyCancellable>()

    public init(viewModel: BooksSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = rootView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        setupTable()
        setupActions()
        bindViewModel()
    }
}

private extension BooksSearchViewController {
    func setupTable() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.register(BookItemCell.self, forCellReuseIdentifier: BookItemCell.reuseID)
    }

    func setupActions() {
        rootView.searchBar.delegate = self
        rootView.refresh.addTarget(
            self, action: #selector(onRefresh), for: .valueChanged
        )
    }

    func bindViewModel() {
        let state = viewModel.$state
            .receive(on: RunLoop.main)
            .share()

        state
            .map(\.items)
            .removeDuplicates{ lhs, rhs in
                lhs.map(\.isbn13) == rhs.map(\.isbn13)
            }
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &bag)

        state
            .map(\.isLoading)
            .removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self else { return }
                if !isLoading {
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
                print("Error:", msg)
            }
            .store(in: &bag)
    }
}

private extension BooksSearchViewController {
    @objc func onRefresh() {
        let current = viewModel.state.query
        guard !current.isEmpty else {
            rootView.refresh.endRefreshing()
            return
        }
        viewModel.send(.search(current))
    }

    func handle(route: BooksSearchViewModel.Route) {
        switch route {
        case .detail(let item):
            print("ISBN13: \(item.isbn13)\n\(item.url)")
        }
    }
}

extension BooksSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.send(.search(searchBar.text ?? ""))
        searchBar.resignFirstResponder()
    }
}

extension BooksSearchViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BookItemCell.reuseID, for: indexPath) as? BookItemCell
        else {
            return UITableViewCell()
        }

        let item = viewModel.state.items[indexPath.row]
        cell.configure(with: item)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension BooksSearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.state.items[indexPath.row]
        viewModel.send(.selectItem(item))
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        let height = scrollView.bounds.height

        if offsetY > contentH - height * 1.3 {
            viewModel.send(.loadMore)
        }
    }
}
