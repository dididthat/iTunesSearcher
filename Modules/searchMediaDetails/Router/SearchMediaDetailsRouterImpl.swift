//
//  SearchMediaDetailsRouterImpl.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsRouterImp: SearchMediaDetailsRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func openUrl(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
