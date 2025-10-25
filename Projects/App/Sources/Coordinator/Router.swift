//
//  Router.swift
//  App
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

@MainActor
public protocol Router: AnyObject {
    func start()
}

@MainActor
public protocol ChildManaging: AnyObject {
    var children: [Router] { get set }
    func add(_ child: Router)
    func remove(_ child: Router)
}

@MainActor
public extension ChildManaging {
    func add(_ child: Router) { children.append(child) }
    func remove(_ child: Router) { children.removeAll { $0 === child } }
}
