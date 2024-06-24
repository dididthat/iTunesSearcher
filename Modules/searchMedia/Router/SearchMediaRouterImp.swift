//
//  SearchMediaRouterImp.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaRouterImp: SearchMediaRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetails(
        viewModel: SearchDetailsViewModel,
        imagesProvider: ImagesProvider
    ) {
        guard let navigationController else { return }
        let flow = SearchMediaDetailsAssemblyImpl().module(navigationController: navigationController, viewModel: viewModel)
        navigationController.pushViewController(flow, animated: true)
    }
}
