//
//  SearchCollectionViewCell.swift
//  searchMedia
//
//  Created by snydia on 11.04.2024.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    static let indentifire = "SearchCollectionViewCell"
    
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let release: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let extraTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(release)
        contentView.addSubview(extraTextLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            release.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            release.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            release.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            extraTextLabel.topAnchor.constraint(equalTo: release.bottomAnchor, constant: 4),
            extraTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            extraTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            extraTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        release.text = nil
        extraTextLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultItem) {
        titleLabel.text = viewModel.artistName
        subtitleLabel.text = viewModel.trackName ?? viewModel.collectionName
        release.text = viewModel.releaseDate?.formatted()
        extraTextLabel.text = viewModel.kind ?? viewModel.wrapperType
    }
}
