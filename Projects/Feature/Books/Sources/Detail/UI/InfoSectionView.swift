//
//  DetailInfoSectionView.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

final class InfoSectionView: UIView {

    // MARK: - Subviews
    private let titleLabel = UILabel()
    private let stack = UIStackView()
    private let container = UIStackView()

    // MARK: - Model
    struct Row { let key: String; let value: String }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Setup
private extension InfoSectionView {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    func setupProperties() {
        titleLabel.text = "정보"
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 6

        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 8
    }

    func setupHierarchy() {
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(stack)
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

// MARK: - Configure
extension InfoSectionView {
    func configure(_ rows: [Row]) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for row in rows {
            let h = UIStackView()
            h.axis = .horizontal
            h.alignment = .firstBaseline
            h.spacing = 8

            let k = UILabel()
            k.font = .preferredFont(forTextStyle: .footnote)
            k.textColor = .secondaryLabel
            k.setContentHuggingPriority(.required, for: .horizontal)
            k.text = "\(row.key):"

            let v = UILabel()
            v.font = .preferredFont(forTextStyle: .footnote)
            v.textColor = .secondaryLabel
            v.numberOfLines = 0
            v.text = row.value

            h.addArrangedSubview(k)
            h.addArrangedSubview(v)
            stack.addArrangedSubview(h)
        }

        isHidden = rows.isEmpty
    }
}
