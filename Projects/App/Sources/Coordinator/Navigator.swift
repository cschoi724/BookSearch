//
//  Navigator.swift
//  App
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

public protocol Navigator {
    @MainActor func setRoot(_ vc: UIViewController, animated: Bool)
    @MainActor func push(_ vc: UIViewController, animated: Bool)
    @MainActor func present(_ vc: UIViewController, animated: Bool) async
    @MainActor func pop(animated: Bool)
    @MainActor func dismiss(animated: Bool)
}

@MainActor
public final class NavigationControllerNavigator: Navigator {
    private let nav: UINavigationController
    
    public init(nav: UINavigationController) {
        self.nav = nav
    }
    
    public func setRoot(_ vc: UIViewController, animated: Bool) {
        nav.setViewControllers([vc], animated: animated)
    }
    
    public func push(_ vc: UIViewController, animated: Bool) { nav.pushViewController(vc, animated: animated)
    }
    
    public func present(_ vc: UIViewController, animated: Bool) {
        nav.present(vc, animated: animated)
    }
    
    public func pop(animated: Bool) {
        nav.popViewController(animated: animated)
    }

    public func dismiss(animated: Bool) {
        nav.presentedViewController?.dismiss(animated: animated)
    }
}
