//
//  SearchMediaAssemblyImpl.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaAssemblyImpl: SearchMediaAssembly {
    func module(navigationController: UINavigationController) -> UIViewController {
        let imagesProvider = ImagesProvider()
        let interactor = SearchMediaInteractorImp(imagesProvider: imagesProvider)
        let router = SearchMediaRouterImp(navigationController: navigationController)
        let presenter = SearchMediaPresenterImpl(interactor: interactor, router: router, imagesProvider: imagesProvider)
        let viewController = SearchMediaViewController()
        presenter.view = viewController
        viewController.addDisposable(presenter)
        return viewController
    }
}
