//
//  DetailBuilder.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain

public enum DetailBuilder {
    @MainActor
    public static func make(
        item: BookItem,
        router: DetailRouter,
        fetchBookDetail: FetchBookDetailUseCase
    ) -> UIViewController {
        let viewModel = BooksDetailViewModel(
            initialItem: item,
            dependency: .init(fetchBookDetail: fetchBookDetail)
        )
        return BooksDetailViewController(
            viewModel: viewModel,
            router: router
        )
    }
}
