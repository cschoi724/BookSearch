//
//  SceneDelegate.swift
//  App
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import BooksFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)

        let rootVC = AppDependency.shared.makeBooksSearchRoot()
        let nav = UINavigationController(rootViewController: rootVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}
