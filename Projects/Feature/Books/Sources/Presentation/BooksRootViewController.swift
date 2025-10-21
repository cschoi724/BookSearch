//
//  BooksRootViewController.swift
//  Books
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

public final class BooksRootViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Hello World!"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Books"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
