//
//  AppCoordinator.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

final class AppCoordinator {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func start() {
        let flow = SearchFlowFactory().searchFlow()
        navigationController?.pushViewController(flow, animated: true)
    }
}
