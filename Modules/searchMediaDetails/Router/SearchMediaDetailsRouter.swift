//
//  SearchMediaDetailsRouter.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import Foundation

protocol SearchMediaDetailsRouter: AnyObject {
    func navigateBack()
    func openUrl(_ url: URL)
}
