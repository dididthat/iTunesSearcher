//
//  SearchPresenter.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

enum SearchCellType {
    case history(String)
    case result(SearchResultItem)
}

protocol SearchFlowOutput {
    var data: [SearchCellType] { get }
    
    func update(text: String?)
    func searchBarDidFocus()
    func searchBarDidUnfocus()
    func searchButtonDidTap(text: String?)
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void)
}

final class SearchPresenter: SearchFlowOutput {
    private(set) var data: [SearchCellType] = []
    
    weak var input: SearchFlowInput?
    private var searchHistory: [String] = []
    private let networkClient = NetworkClient()
    private let imagesProvider = ImagesProvider()
    private var searchDataItemResult: [SearchResultItem] = []
    
    init() {
        readHistory()
    }
    
    func update(text: String?) {
        guard let text, !text.isEmpty else { return }
        
        data = searchHistory
            .filter { $0.lowercased().contains(text.lowercased()) }
            .map { .history($0) }
            .reversed()
        
        input?.reloadData()
    }
    
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard
            let urlString,
            let url = URL(string: urlString)
        else {
            return
        }
        imagesProvider.image(url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func searchBarDidFocus() {
        data = searchHistory
            .map { .history($0) }
            .reversed()
        input?.switchState(to: .history)
        input?.reloadData()
    }
    
    func searchBarDidUnfocus() {
        data = searchDataItemResult.map { .result($0) }
        input?.switchState(to: .result)
        input?.reloadData()
    }
    
    func searchButtonDidTap(text: String?) {
        data = []
        
        guard let text, !text.isEmpty else { return }
        networkClient.fetch(
            .search(
                params: .init(request: text, entities: [.audiobook, .movie], limit: .firstLimit )
            )
        ) { [weak self] (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let result):
                self?.searchDataItemResult = result.results
                self?.data = result.results.map({ item in
                        .result(item)
                })
                DispatchQueue.main.async {
                    self?.input?.reloadData()
                }
                
            case .failure:
                print("failure")
            }
        }
        
        if !searchHistory.contains(text) {
            if searchHistory.count == 5 {
                searchHistory.removeFirst()
            }
            searchHistory.append(text)
            saveHistory()
        }
        
        input?.switchState(to: .result)
        input?.reloadData()
    }
    
    private func saveHistory() {
        UserDefaults.standard.set(searchHistory, forKey: "history")
    }
    
    private func readHistory() {
        searchHistory = UserDefaults.standard.array(forKey: "history") as? [String] ?? []
    }
}
