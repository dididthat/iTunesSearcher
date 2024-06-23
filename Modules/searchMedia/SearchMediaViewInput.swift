//
//  SearchMediaViewInput.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

protocol SearchMediaViewInput: AnyObject {
    var numberOfItemsInSection: (() -> Int)? { get set }
    var didSelectItem: ((Int) -> Void)? { get set }
    var updateText: ((String?) -> Void)? { get set }
    var searchButtonDidTap: ((String?) -> Void)? { get set }
    var searchBarDidFocus: (() -> Void)? { get set }
    var searchBarDidUnFocus: (() -> Void)? { get set }
    var typeForIndex: ((Int) -> SearchCellType?)? { get set }
    var loadImage: ((String?, @escaping (UIImage?) -> Void) -> Void)? { get set }
    func switchState(to state: SearchFlowState)
    func reloadData()
    func setupSearchText(_ text: String)
    func changeErrorVisibility(for isShown: Bool)
}
