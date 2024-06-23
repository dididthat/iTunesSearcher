//
//  SearchMediaDetailsAssemblyImpl.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsAssemblyImpl: SearchMediaDetailsAssembly {
    func module(navigationController: UINavigationController, viewModel: SearchDetailsViewModel) -> UIViewController {
        let imagesProvider = ImagesProvider()
        let interactor = SearchMediaDetailsInteractorImpl(imagesProvider: imagesProvider)
        let router = SearchMediaDetailsRouterImp(navigationController: navigationController)
        let presenter = SearchMediaDetailsPresenterImpl(interactor: interactor, router: router, imagesProvider: imagesProvider, viewModel: viewModel)
        let viewController = SearchMediaDetailsViewController()
        presenter.view = viewController
        viewController.addDisposable(presenter)
        return viewController
    }
}
