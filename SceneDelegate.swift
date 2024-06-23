//
//  SceneDelegate.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
//    private var : AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        let viewController = SearchMediaAssemblyImpl().module(navigationController: navigationController)
        navigationController.viewControllers = [viewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
