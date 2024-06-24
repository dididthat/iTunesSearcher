//
//  SearchMediaInteractor.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

protocol SearchMediaInteractor: AnyObject {
    func saveHistory(searchHistory: [String])
    func readHistory() -> [String]
    func search(text: String, completion:  @escaping (Result<SearchResult, Error>) -> Void)
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
}
