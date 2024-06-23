//
//  SearchMediaInteractorImp.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaInteractorImp: SearchMediaInteractor {
    var searchButtonDidTapped: ((String?) -> Void)?
    private let networkClient = NetworkClient()
    private let imagesProvider: ImagesProvider
    
    init(imagesProvider: ImagesProvider){
        self.imagesProvider = imagesProvider
    }
    
    func saveHistory(searchHistory: [String]) {
        UserDefaults.standard.set(searchHistory, forKey: "history")
    }
    
    func readHistory() -> [String] {
        UserDefaults.standard.array(forKey: "history") as? [String] ?? []
    }
    
    func search(text: String, completion:  @escaping (Result<SearchResult, Error>) -> Void) {
        networkClient.fetch(
            .search(
                params: .init(request: text, entities: [.audiobook, .movie], limit: .firstLimit)
            ), completion: completion)
    }
    
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        imagesProvider.image(url, completion: completion)
    }
}
