//
//  DetailInfoSectionView.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

final class InfoSectionView: UIView {

    private let titleLabel = UILabel()
    private let vStack = UIStackView()
    private let container = UIStackView()

    struct Row {
        let key: String
        let value: String
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension InfoSectionView {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    func setupProperties() {
        titleLabel.text = "정보"
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)

        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 6

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

extension InfoSectionView {
    func configure(_ rows: [Row]) {
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for row in rows {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .firstBaseline
            hStack.spacing = 8

            let keyLabel = UILabel()
            keyLabel.font = .preferredFont(forTextStyle: .footnote)
            keyLabel.textColor = .secondaryLabel
            keyLabel.setContentHuggingPriority(.required, for: .horizontal)
            keyLabel.text = "\(row.key):"

            let valueLabel = UILabel()
            valueLabel.font = .preferredFont(forTextStyle: .footnote)
            valueLabel.textColor = .secondaryLabel
            valueLabel.numberOfLines = 0
            valueLabel.text = row.value

            hStack.addArrangedSubview(keyLabel)
            hStack.addArrangedSubview(valueLabel)
            vStack.addArrangedSubview(hStack)
        }

        isHidden = rows.isEmpty
    }
}
