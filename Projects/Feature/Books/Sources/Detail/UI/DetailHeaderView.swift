//
//  DetailHeaderView.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

final class DetailHeaderView: UIView {

    private let coverView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let hStack = UIStackView()
    private let vStack = UIStackView()

    struct Model {
        let coverURL: String?
        let title: String
        let subtitle: String?
        let price: String?
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension DetailHeaderView {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    func setupProperties() {
        backgroundColor = .clear

        coverView.contentMode = .scaleAspectFit
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 8
        coverView.backgroundColor = .secondarySystemBackground

        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        priceLabel.font = .preferredFont(forTextStyle: .headline)

        hStack.axis = .horizontal
        hStack.alignment = .top
        hStack.spacing = 16

        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 6
    }

    func setupHierarchy() {
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(priceLabel)

        hStack.addArrangedSubview(coverView)
        hStack.addArrangedSubview(vStack)

        addSubview(hStack)
    }

    func setupConstraints() {
        coverView.translatesAutoresizingMaskIntoConstraints = false
        hStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverView.widthAnchor.constraint(equalToConstant: 140),
            coverView.heightAnchor.constraint(equalToConstant: 180),

            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension DetailHeaderView {
    func configure(_ model: Model) {
        coverView.setImage(from: model.coverURL)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = (model.subtitle == nil)
        priceLabel.text = model.price
        priceLabel.isHidden = (model.price == nil)
    }
}
