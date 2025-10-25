//
//  BooksSearchView.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

final class BooksSearchView: UIView {
    let searchBar = UISearchBar(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .plain)
    let emptyView = EmptyView()
    let refresh = UIRefreshControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        emptyView.frame = tableView.bounds
    }
    
    private func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    private func setupProperties() {
        backgroundColor = .systemBackground
        searchBar.placeholder = "책 제목/키워드 검색"
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.refreshControl = refresh
        tableView.register(BookItemCell.self, forCellReuseIdentifier: BookItemCell.reuseID)
        
        emptyView.title = "검색결과가 없습니다"
        emptyView.isHidden = true

        tableView.backgroundView = emptyView
        emptyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
    }

    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let g = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: g.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    
        ])
    }
    
    func setEmptyState(isShown: Bool, message: String = "검색결과가 없습니다") {
        emptyView.title = message
        emptyView.isHidden = !isShown
        emptyView.frame = tableView.bounds
    }
}

