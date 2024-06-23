//
//  SearchMediaDetailsPresenterImpl.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsPresenterImpl: SearchMediaDetailsPresenter {
    
    weak var view: SearchMediaDetailsViewInput? {
        didSet {
            setUpView()
        }
    }
    
    private let interactor: SearchMediaDetailsInteractor
    private let router: SearchMediaDetailsRouter
    private let imagesProvider: ImagesProvider
    private var artistModel: SearchDetailsArtistModel?
    private var viewModel: SearchDetailsViewModel
    
    init(
        interactor: SearchMediaDetailsInteractor,
        router: SearchMediaDetailsRouter,
        imagesProvider: ImagesProvider,
        viewModel: SearchDetailsViewModel
    ) {
        self.interactor = interactor
        self.router = router
        self.viewModel = viewModel
        self.imagesProvider = imagesProvider
    }
    
    func displayArtistInfo(_ model: SearchDetailsArtistModel) {
        view?.displayArtistInfo(model)
    }
    
    func backButtonTapped() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        guard let id = viewModel.artistId else { return }
        interactor.searchArtist(id: id) { [weak self] (result: Result<SearchDetailsArtistDTO, Error>) in
            switch result {
            case .success(let value):
                guard
                    let model = value.results.first.flatMap({ SearchDetailsArtistDTOToDomainConverter().convert(from: $0) })
                else {
                    return
                }
                self?.artistModel = model
                DispatchQueue.main.async {
                    self?.view?.displayArtistInfo(model)
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.changeErrorVisibility(for: true)
                }
            }
        }
    }
    
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
        interactor.loadImage(for: urlString) { image in
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
        
        if let url = url {
            router.openUrl(url)
        }
    }
    
    private func setUpView() {
        view?.loadImage = { [weak self] in
            self?.loadImage(for: $0, completion: $1)
        }
        
        view?.model = { [weak self] in
            self?.viewModel
        }
        
        view?.onViewDidLoad = { [weak self] in
            self?.viewDidLoad()
        }
        
        view?.hyperLinkDidTap = { [weak self] in
            self?.hyperLinkDidTap(of: $0)
        }
        
        view?.onBackButtonTap = { [weak self] in
            self?.backButtonTapped()
        }
    }
}

