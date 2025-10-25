//
//  BookItemCell.swift
//  Books
//
//  Created by 일하는석찬 on 10/24/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain

final class BookItemCell: UITableViewCell {
    static let reuseID = "BookItemCell"

    private let thumbView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let isbnLabel = UILabel()
    private let urlLabel = UILabel()
    private let rightStack = UIStackView()
    
    private enum Metric {
        static let hPadding: CGFloat = 12
        static let vPadding: CGFloat = 8
        static let hGap: CGFloat = 12
        static let vSpacing: CGFloat = 4
        static let thumbSize: CGFloat = 48
        static let thumbCorner: CGFloat = 8
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbView.cancelImageLoad()
        thumbView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil
        isbnLabel.text = nil
        urlLabel.text = nil
    }

    func configure(with item: BookItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        priceLabel.text = item.price
        isbnLabel.text = "ISBN13: \(item.isbn13)"
        urlLabel.text = item.url
        thumbView.setImage(from: item.image)
    }
}

private extension BookItemCell {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }

    func setupProperties() {
        selectionStyle = .none
        contentView.preservesSuperviewLayoutMargins = true
        contentView.directionalLayoutMargins = .init(
            top: Metric.vPadding,
            leading: Metric.hPadding,
            bottom: Metric.vPadding,
            trailing: Metric.hPadding
        )

        thumbView.contentMode = .scaleAspectFill
        thumbView.clipsToBounds = true
        thumbView.layer.cornerRadius = Metric.thumbCorner
        thumbView.backgroundColor = .secondarySystemFill

        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        priceLabel.textColor = .systemBlue

        isbnLabel.font = .systemFont(ofSize: 12)
        isbnLabel.textColor = .tertiaryLabel

        urlLabel.font = .systemFont(ofSize: 12)
        urlLabel.textColor = .tertiaryLabel
        urlLabel.lineBreakMode = .byTruncatingMiddle

        rightStack.axis = .vertical
        rightStack.spacing = Metric.vSpacing
        rightStack.alignment = .fill
        rightStack.distribution = .fill
    }

    func setupHierarchy() {
        rightStack.addArrangedSubview(titleLabel)
        rightStack.addArrangedSubview(subtitleLabel)
        rightStack.addArrangedSubview(priceLabel)
        rightStack.addArrangedSubview(isbnLabel)
        rightStack.addArrangedSubview(urlLabel)

        contentView.addSubview(thumbView)
        contentView.addSubview(rightStack)
    }

    func setupConstraints() {
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            thumbView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbView.widthAnchor.constraint(equalToConstant: Metric.thumbSize),
            thumbView.heightAnchor.constraint(equalToConstant: Metric.thumbSize),

            rightStack.leadingAnchor.constraint(equalTo: thumbView.trailingAnchor, constant: Metric.hGap),
            rightStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            rightStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            rightStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
