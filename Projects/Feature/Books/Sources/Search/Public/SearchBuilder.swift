//
//  SearchBuilder.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import Domain

public enum SearchBuilder {
    @MainActor
    public static func make(
        router: SearchRouter,
        searchBooks: SearchBooksUseCase
    ) -> UIViewController {
        let viewModel = BooksSearchViewModel(
            dependency: .init(searchBooksUseCase: searchBooks)
        )
        return BooksSearchViewController(
            viewModel: viewModel,
            router: router
        )
    }
}
