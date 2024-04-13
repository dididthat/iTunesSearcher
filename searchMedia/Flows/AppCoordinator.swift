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
        let flow = SearchFlowFactory().searchFlow(navigationDelegate: self)
        navigationController?.viewControllers = [flow]
    }
}

// MARK: - SearchPresenterNavigationDelegate
extension AppCoordinator: SearchPresenterNavigationDelegate {
    func searchDetailsPresenterDidRequestOpenDetailsFlow(
        _ presenter: SearchPresenter,
        viewModel: SearchDetailsViewModel,
        imagesProvider: ImagesProvider
    ) {
        let flow = SearchDetailsFlowFactory().searchDetailsFlow(viewModel: viewModel, imagesProvider: imagesProvider)
        navigationController?.pushViewController(flow, animated: true)
    }
}
