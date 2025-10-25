//
//  DetailRouter.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

@MainActor
public protocol DetailRouter: AnyObject {
    func go(_ route: DetailRoute)
}

public enum DetailRoute: Equatable {
    case openWeb(url: URL)
}
