//
//  SearchMediaDetailsAssembly.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

protocol SearchMediaDetailsAssembly: AnyObject {
    func module(navigationController: UINavigationController, viewModel: SearchDetailsViewModel) -> UIViewController
}
