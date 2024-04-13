//
//  SearchViewController.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

enum SearchFlowState {
    case history
    case result
}

protocol SearchFlowInput: AnyObject {
    func switchState(to state: SearchFlowState)
    func reloadData()
    func setupSearchText(_ text: String)
    func changeErrorVisibility(for isShown: Bool)
}

final class SearchViewController: UIViewController {
    private let output: SearchFlowOutput
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutHistory())
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.indentifire
        )
        collectionView.register(
            HistoryCollectionViewCell.self,
            forCellWithReuseIdentifier: HistoryCollectionViewCell.indentifire
        )
        collectionView.register(
            SkeletonCollectionViewCell.self,
            forCellWithReuseIdentifier: SkeletonCollectionViewCell.indentifire
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let errorImageView: UIImageView = {
        let errorImageView = UIImageView()
        errorImageView.image = UIImage(named: "error")
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.isHidden = true
        errorImageView.contentMode = .scaleAspectFit
        return errorImageView
    }()
    
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        errorLabel.textAlignment = .center
        errorLabel.text = "Please try again"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        return errorLabel
    }()
    
    init(output: SearchFlowOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor, constant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 50),
        ])
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Введите поисковой запрос", comment: "")
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func createLayoutResult() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(20)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createLayoutHistory() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - SearchFlowInput
extension SearchViewController: SearchFlowInput {
    func switchState(to state: SearchFlowState) {
        switch state {
        case .history:
            collectionView.collectionViewLayout = createLayoutHistory()
            
        case .result:
            collectionView.collectionViewLayout = createLayoutResult()
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func setupSearchText(_ text: String) {
        navigationItem.searchController?.searchBar.text = text
    }
    
    func changeErrorVisibility(for isShown: Bool) {
        errorImageView.isHidden = !isShown
        errorLabel.isHidden = !isShown
        collectionView.isHidden = isShown
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        output.update(text: searchController.searchBar.text)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        output.searchButtonDidTap(text: searchBar.text)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        output.searchBarDidFocus()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.searchBarDidUnfocus()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return output.data.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let type = output.data[indexPath.row]
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
        output.loadImage(for: value.artworkUrl100) { [weak self] in
            (self?.collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell)?.image = $0
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
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectItem(at: indexPath.row)
    }
}
