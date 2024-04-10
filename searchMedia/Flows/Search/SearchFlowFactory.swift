//
//  SearchFlowFactory.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

struct SearchFlowFactory {
    func searchFlow() -> UIViewController {
        let presenter = SearchPresenter()
        let viewController = SearchViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}
