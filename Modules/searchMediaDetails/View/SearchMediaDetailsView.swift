//
//  SearchMediaDetailsView.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsView: UIView {
    
    var model: (() -> SearchDetailsViewModel?)? {
        didSet { setUpModel() }
    }
    
    var loadImage: ((String?, @escaping (UIImage?) -> Void) -> Void)? {
        didSet { setUpModel() }
    }
    
    var hyperLinkDidTap: ((SearchDetailsHyperLinkType) -> Void?)?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    
    private let aboutArtistTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Additonal info"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        return label
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
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutTrackHyperLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Learn more..."
        label.textColor = .systemBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hyperLinkLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var aboutAnArtistHyperLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Learn more..."
        label.textColor = .systemBlue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hyperLinkLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    
    private lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var artistNameAndKindStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistNameLabel, kindLabel, releaseDateLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistNameAndKindStackView, aboutTrackHyperLinkLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var posterImageAndInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, infoStackView])
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameAndTypeArtistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var primaryArtistGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var artistInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameAndTypeArtistLabel, primaryArtistGenreLabel, aboutAnArtistHyperLinkLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        addSubviews([
            scrollView,
            errorImageView,
            errorLabel
        ])
        
        scrollView.addSubviews([
            posterImageAndInfoStackView,
            separatorView,
            descriptionTextLabel,
            descriptionTitleLabel,
            aboutArtistTitleLabel,
            artistInfoStackView
        ])
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayArtistInfo(_ model: SearchDetailsArtistModel) {
        artistInfoStackView.isHidden = false
        aboutArtistTitleLabel.isHidden = false
        if let artistName = model.artistName, let artistType = model.artistType {
            nameAndTypeArtistLabel.text = "\(artistName) - \(artistType)"
        }
        if let primaryGenreName = model.primaryGenreName {
            primaryArtistGenreLabel.text = "Primary genre - \(primaryGenreName)"
        }
    }
    
    func changeErrorVisibility(for isShown: Bool) {
        errorImageView.isHidden = !isShown
        errorLabel.isHidden = !isShown
        scrollView.isHidden = isShown
    }
    
    private func setUpView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            posterImageAndInfoStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            posterImageAndInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            posterImageAndInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            infoStackView.heightAnchor.constraint(equalTo: posterImageView.heightAnchor),
            
            separatorView.topAnchor.constraint(equalTo: posterImageAndInfoStackView.bottomAnchor, constant: 32),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            aboutArtistTitleLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16),
            aboutArtistTitleLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            
            artistInfoStackView.topAnchor.constraint(equalTo: aboutArtistTitleLabel.bottomAnchor, constant: 8),
            artistInfoStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            artistInfoStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            artistInfoStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            
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
    
    private func setUpModel() {
        guard let model = model?() else { return }
        artistNameLabel.text = model.artistName
        kindLabel.text = model.kind
        releaseDateLabel.text = model.releaseDate
        
        if let description = model.description, !description.isEmpty {
            descriptionTextLabel.text = description
        } else {
            descriptionTextLabel.text = "There is no description for this content."
        }
        
        loadImage?(model.artWorkUrl) { [weak self] in
            self?.posterImageView.image = $0
        }
    }
    
    @objc
    private func hyperLinkLabelTapped(_ recognizer: UITapGestureRecognizer) {
        let type: SearchDetailsHyperLinkType = recognizer.view === aboutTrackHyperLinkLabel ? .aboutTrack : .aboutAnArtist
        hyperLinkDidTap?(type)
    }
}
