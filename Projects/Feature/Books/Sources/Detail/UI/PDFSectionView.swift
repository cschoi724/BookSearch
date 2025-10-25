//
//  PDFSectionView.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain

final class PDFSectionView: UIView {

    var onTap: ((URL) -> Void)?

    private let titleLabel = UILabel()
    private let vStack = UIStackView()
    private let container = UIStackView()

    private var urls: [URL] = []

    struct Item { let title: String; let url: URL }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PDFSectionView {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    func setupProperties() {
        titleLabel.text = "PDF"
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)

        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 8

        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 8
    }

    func setupHierarchy() {
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(vStack)
        addSubview(container)
    }

    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension PDFSectionView {
    func configure(_ items: [Item]) {
        urls = items.map(\.url)
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (idx, item) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(item.title, for: .normal)
            button.contentHorizontalAlignment = .leading
            button.tag = idx
            button.addTarget(self, action: #selector(onTapButton(_:)), for: .touchUpInside)
            vStack.addArrangedSubview(button)
        }

        isHidden = items.isEmpty
    }

    @objc private func onTapButton(_ sender: UIButton) {
        guard urls.indices.contains(sender.tag) else { return }
        onTap?(urls[sender.tag])
    }
}
