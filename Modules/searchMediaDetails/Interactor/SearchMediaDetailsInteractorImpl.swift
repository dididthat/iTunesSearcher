//
//  SearchMediaDetailsInteractorImpl.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsInteractorImpl: SearchMediaDetailsInteractor {
    private let imagesProvider: ImagesProvider
    private let networkClient = NetworkClient()
    
    init(imagesProvider: ImagesProvider){
        self.imagesProvider = imagesProvider
    }
    
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = urlString.flatMap({ URL(string: $0) }) else { return }
        imagesProvider.image(url, completion: completion)
    }
    
    func searchArtist(id: Int, completion:  @escaping (Result<SearchDetailsArtistDTO, Error>) -> Void) {
        networkClient.fetch((.searchArtist(id: id)), completion: completion)
    }
}
