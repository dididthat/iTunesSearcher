//
//  SearchMediaViewController.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaViewController:
    UIViewController,
    SearchMediaViewInput
{
    var numberOfItemsInSection: (() -> Int)?
    var typeForIndex: ((Int) -> SearchCellType?)?
    var didSelectItem: ((Int) -> Void)?
    var updateText: ((String?) -> Void)?
    var searchButtonDidTap: ((String?) -> Void)?
    var searchBarDidFocus: (() -> Void)?
    var searchBarDidUnFocus: (() -> Void)?
    var loadImage: ((String?, @escaping (UIImage?) -> Void) -> Void)?
    
    private var disposables: [AnyObject] = []
    private lazy var contentView = SearchMediaView(dataSource: self, delegate: self)
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Введите поисковой запрос", comment: "")
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func switchState(to state: SearchFlowState) {
        contentView.switchState(to: state)
    }
    
    func reloadData() {
        contentView.reloadData()
    }
    
    func setupSearchText(_ text: String) {
        navigationItem.searchController?.searchBar.text = text
    }
    
    func changeErrorVisibility(for isShown: Bool) {
        contentView.changeErrorVisibility(for: isShown)
    }
    
    func addDisposable(_ object: AnyObject) {
        disposables.append(object)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchMediaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateText?(searchController.searchBar.text)
    }
}

// MARK: - UISearchBarDelegate
extension SearchMediaViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonDidTap?(searchBar.text)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarDidFocus?()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarDidUnFocus?()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchMediaViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return numberOfItemsInSection?() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let type = typeForIndex?(indexPath.row) else { return UICollectionViewCell() }
        switch type {
        case .history(let value):
            return configuredHistoryCell(collectionView, cellForItemAt: indexPath, text: value)
        case .result(let value):
            return configuredResultCell(collectionView, cellForItemAt: indexPath, value: value)
        case .skeleton:
            return configuredSkeletonCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func configuredHistoryCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath,
        text: String
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryCollectionViewCell.indentifire,
            for: indexPath
        ) as? HistoryCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(text: text)
        return cell
    }
    
    private func configuredResultCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath,
        value: SearchResultItem
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.indentifire,
            for: indexPath
        ) as? SearchCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: value)
        loadImage?(value.artworkUrl100) { [weak collectionView]  in
           (collectionView?.cellForItem(at: indexPath) as? SearchCollectionViewCell)?.image = $0
        }
        return cell
    }
    
    private func configuredSkeletonCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SkeletonCollectionViewCell.indentifire,
            for: indexPath
        ) as? SkeletonCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchMediaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath.row)
    }
}
