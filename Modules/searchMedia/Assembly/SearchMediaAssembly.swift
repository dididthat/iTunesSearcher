//
//  SearchMediaAssembly.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

protocol SearchMediaAssembly: AnyObject {
    func module(navigationController: UINavigationController) -> UIViewController
}
