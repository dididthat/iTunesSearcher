//
//  SearchMediaRouter.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import Foundation

protocol SearchMediaRouter: AnyObject {
    func showDetails(
        viewModel: SearchDetailsViewModel,
        imagesProvider: ImagesProvider
    )
}
