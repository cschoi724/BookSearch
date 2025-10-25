//
//  SearchRouter.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Domain

@MainActor
public protocol SearchRouter: AnyObject {
    func go(_ route: SearchRoute)
}

public enum SearchRoute: Equatable {
    case detail(item: BookItem)
}
