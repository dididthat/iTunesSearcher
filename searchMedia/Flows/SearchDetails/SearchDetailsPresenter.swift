//
//  SearchDetailsPresenter.swift
//  searchMedia
//
//  Created by snydia on 13.04.2024.
//

import UIKit

enum SearchDetailsHyperLinkType {
    case aboutTrack
    case aboutAnArtist
}

protocol SearchDetailsFlowOutput: AnyObject {
    var viewModel: SearchDetailsViewModel { get }
    
    func viewDidLoad()
    func hyperLinkDidTap(of type: SearchDetailsHyperLinkType)
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void)
}

final class SearchDetailsPresenter: SearchDetailsFlowOutput {
    weak var input: SearchDetailsFlowInput?
    
    private(set) var viewModel: SearchDetailsViewModel
    
    private let imagesProvider: ImagesProvider
    private let networkClient = NetworkClient()
    
    private var artistModel: SearchDetailsArtistModel?
    
    init(
        viewModel: SearchDetailsViewModel,
        imagesProvider: ImagesProvider
    ) {
        self.viewModel = viewModel
        self.imagesProvider = imagesProvider
    }
    
    func viewDidLoad() {
        guard let id = viewModel.artistId else { return }
        
        networkClient.fetch(.searchArtist(id: id)) { [weak self] (result: Result<SearchDetailsArtistDTO, Error>) in
            switch result {
            case .success(let value):
                guard
                    let model = value.results.first.flatMap({ SearchDetailsArtistDTOToDomainConverter().convert(from: $0) })
                else {
                    return
                }
                self?.artistModel = model
                DispatchQueue.main.async {
                    self?.input?.displayArtistInfo(model)
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self?.input?.changeErrorVisibility(for: true)
                }
            }
        }
    }
    
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = urlString.flatMap({ URL(string: $0) }) else { return }
        
        imagesProvider.image(url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func hyperLinkDidTap(of type: SearchDetailsHyperLinkType) {
        let url: URL?
        switch type {
        case .aboutTrack:
            url = viewModel.trackViewUrlString.flatMap { URL(string: $0) }
            
        case .aboutAnArtist:
            let urlString = artistModel?.artistLinkUrl ?? artistModel?.artistViewUrl ?? artistModel?.trackViewUrl
            url = urlString.flatMap { URL(string: $0) }
        }
        
        if let url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
