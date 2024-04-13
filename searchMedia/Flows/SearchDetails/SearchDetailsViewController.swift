//
//  SearchDetailsViewController.swift
//  searchMedia
//
//  Created by snydia on 13.04.2024.
//

import UIKit

protocol SearchDetailsFlowInput: AnyObject {
    func displayArtistInfo(_ model: SearchDetailsArtistModel)
    func changeErrorVisibility(for isShown: Bool)
}

final class SearchDetailsViewController: UIViewController {
    
    private let output: SearchDetailsFlowOutput
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
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
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        return label
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
    
    private let aboutArtistTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Additonal info"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        label.isHidden = true
        return label
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
    
    init(output: SearchDetailsFlowOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
        makeConstraints()
        
        output.viewDidLoad()
    }
    
    private func setup() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        
        let model = output.viewModel
        navigationItem.title = model.trackName
        artistNameLabel.text = model.artistName
        kindLabel.text = model.kind
        releaseDateLabel.text = model.releaseDate
        if let description = model.description, !description.isEmpty {
            descriptionTextLabel.text = description
        } else {
            descriptionTextLabel.text = "There is no description for this content."
        }
        
        output.loadImage(for: model.artWorkUrl) { [weak self] in
            self?.posterImageView.image = $0
        }
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        scrollView.addSubview(posterImageAndInfoStackView)
        scrollView.addSubview(separatorView)
        scrollView.addSubview(descriptionTextLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(aboutArtistTitleLabel)
        scrollView.addSubview(artistInfoStackView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            posterImageAndInfoStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            posterImageAndInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            posterImageAndInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            infoStackView.heightAnchor.constraint(equalTo: posterImageView.heightAnchor),
            
            separatorView.topAnchor.constraint(equalTo: posterImageAndInfoStackView.bottomAnchor, constant: 32),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            aboutArtistTitleLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16),
            aboutArtistTitleLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            
            artistInfoStackView.topAnchor.constraint(equalTo: aboutArtistTitleLabel.bottomAnchor, constant: 8),
            artistInfoStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            artistInfoStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            artistInfoStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor, constant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 50),
        ])
    }
    
    @objc
    private func hyperLinkLabelTapped(_ recognizer: UITapGestureRecognizer) {
        let type: SearchDetailsHyperLinkType = recognizer.view === aboutTrackHyperLinkLabel ? .aboutTrack : .aboutAnArtist
        output.hyperLinkDidTap(of: type)
    }
}

// MARK: - SearchDetailsFlowInput
extension SearchDetailsViewController: SearchDetailsFlowInput {
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
}

