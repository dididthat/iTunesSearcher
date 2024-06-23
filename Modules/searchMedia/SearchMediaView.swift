//
//  SearchMediaView.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaView: UIView {
    
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
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayoutHistory()
    )
    
    init(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        super.init(frame: .zero)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        addSubviews([
            collectionView,
            errorImageView,
            errorLabel
        ])
        backgroundColor = .white

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
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func createLayoutHistory() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func changeErrorVisibility(for isShown: Bool) {
        errorImageView.isHidden = !isShown
        errorLabel.isHidden = !isShown
        collectionView.isHidden = isShown
    }
    
    private func setUpView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor, constant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 50),
        ])
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
}
