//
//  BookDetailView.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain

final class BooksDetailView: UIView {

    var onPDFTapped: ((URL) -> Void)?

    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    let refresh = UIRefreshControl()

    private let headerView = DetailHeaderView()
    private let infoView = InfoSectionView()
    private let descTitleLabel = UILabel()
    let descLabel = UILabel()
    private let pdfView = PDFSectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension BooksDetailView {
    func setup() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
        setupBindings()
    }

    func setupProperties() {
        backgroundColor = .systemBackground

        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 16

        descTitleLabel.text = "설명"
        descTitleLabel.font = .preferredFont(forTextStyle: .subheadline)

        descLabel.font = .preferredFont(forTextStyle: .body)
        descLabel.numberOfLines = 0
    }

    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)
        scrollView.refreshControl = refresh

        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(infoView)
        contentStack.addArrangedSubview(descTitleLabel)
        contentStack.addArrangedSubview(descLabel)
        contentStack.addArrangedSubview(pdfView)
    }

    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let g = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: g.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    func setupBindings() {
        pdfView.onTap = { [weak self] url in
            self?.onPDFTapped?(url)
        }
    }
}

extension BooksDetailView {
    func configure(item: BookItem, detail: BookDetail?) {
        let img = nonEmpty(detail?.image) ?? nonEmpty(item.image)
        let header = DetailHeaderView.Model(
            coverURL: img,
            title: nonEmpty(detail?.title) ?? item.title,
            subtitle: nonEmpty(detail?.subtitle) ?? nonEmpty(item.subtitle),
            price: nonEmpty(detail?.price) ?? nonEmpty(item.price)
        )
        headerView.configure(header)

        var rows: [InfoSectionView.Row] = []
        func add(_ k: String, _ v: String?) {
            if let v, !v.isEmpty { rows.append(.init(key: k, value: v)) }
        }
        add("저자", detail?.authors)
        add("출판사", detail?.publisher)
        add("언어", detail?.language)
        add("출판년도", detail?.year)
        add("페이지", pageText(detail?.pages))
        add("평점", ratingText(detail?.rating))
        add("ISBN-10", detail?.isbn10)
        add("ISBN-13", nonEmpty(detail?.isbn13) ?? nonEmpty(item.isbn13))
        add("링크", nonEmpty(detail?.url) ?? nonEmpty(item.url))
        infoView.configure(rows)

        descLabel.text = nonEmpty(detail?.desc)
        let noDesc = (descLabel.text?.isEmpty ?? true)
        descLabel.isHidden = noDesc
        descTitleLabel.isHidden = noDesc

        let pdfItems: [PDFSectionView.Item] = (detail?.pdfs ?? []).compactMap { pdf in
            let mirror = Mirror(reflecting: pdf).children
            let title = (mirror.first { $0.label == "title" }?.value as? String)
            let urlStr = (mirror.first { $0.label == "url" }?.value as? String)
            guard let urlStr, let url = URL(string: urlStr) else { return nil }
            let shown = (title?.isEmpty == false) ? title! : (URL(string: urlStr)?.lastPathComponent ?? "PDF")
            return .init(title: shown, url: url)
        }
        pdfView.configure(pdfItems)
    }
}

private extension BooksDetailView {
    func nonEmpty(_ s: String?) -> String? {
        guard let s, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return s
    }
    func pageText(_ p: Int?) -> String? { (p ?? 0) > 0 ? "\(p!) 페이지" : nil }
    func ratingText(_ r: Int?) -> String? { (r ?? 0) > 0 ? "★\(r!)" : nil }
}
