//
//  SearchFlowFactory.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

struct SearchFlowFactory {
    func searchFlow(navigationDelegate: SearchPresenterNavigationDelegate) -> UIViewController {
        let presenter = SearchPresenter(navigationDelegate: navigationDelegate)
        let viewController = SearchViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}
