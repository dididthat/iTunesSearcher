////
////  SearchPresenter.swift
////  searchMedia
////
////  Created by snydia on 10.04.2024.
////
//
//import UIKit

//enum SearchCellType {
//    case history(String)
//    case result(SearchResultItem)
//    case skeleton
//    
//    var isHistory: Bool {
//        switch self {
//        case .history:
//            return true
//            
//        case .result, .skeleton:
//            return false
//        }
//    }
//}
//
//protocol SearchFlowOutput {
//    var data: [SearchCellType] { get }
//    
//    func update(text: String?)
//    func searchBarDidFocus()
//    func searchBarDidUnfocus()
//    func searchButtonDidTap(text: String?)
//    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void)
//    func didSelectItem(at index: Int)
//}
//
//protocol SearchPresenterNavigationDelegate: AnyObject {
//    func searchDetailsPresenterDidRequestOpenDetailsFlow(
//        _ presenter: SearchPresenter,
//        viewModel: SearchDetailsViewModel,
//        imagesProvider: ImagesProvider
//    )
//}
//
//final class SearchPresenter: SearchFlowOutput {
//    private(set) var data: [SearchCellType] = []
//    
//    weak var input: SearchFlowInput?
//    private var searchHistory: [String] = []
//    private let networkClient = NetworkClient()
//    private let imagesProvider = ImagesProvider()
//    private var searchDataItemResults: [SearchResultItem] = []
//    private weak var navigationDelegate: SearchPresenterNavigationDelegate?
//////    
//    init(
//        navigationDelegate: SearchPresenterNavigationDelegate
//    ) {
//        self.navigationDelegate = navigationDelegate
//        readHistory()
//    }
//    
//    func update(text: String?) {
//        guard let text else { return }
//        
//        if !text.isEmpty {
//            data = searchHistory
//                .filter { $0.lowercased().contains(text.lowercased()) }
//                .map { .history($0) }
//                .reversed()
//        } else if data.first?.isHistory == true {
//            data = searchHistory
//                .map { .history($0) }
//                .reversed()
//        }
//        
//        input?.reloadData()
//    }
//    
//    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
//        guard
//            let urlString,
//            let url = URL(string: urlString)
//        else {
//            return
//        }
//        imagesProvider.image(url) { image in
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        }
//    }
//    
//    func searchBarDidFocus() {
//        input?.changeErrorVisibility(for: false)
//        data = searchHistory
//            .map { .history($0) }
//            .reversed()
//        input?.switchState(to: .history)
//        input?.reloadData()
//    }
//    
//    func searchBarDidUnfocus() {
//        guard !searchDataItemResults.isEmpty else { return }
//        data = searchDataItemResults.map { .result($0) }
//        input?.switchState(to: .result)
//        input?.reloadData()
//    }
//    
//    func searchButtonDidTap(text: String?) {
//        data = (1...10).map { _ in .skeleton }
//        input?.switchState(to: .result)
//        input?.reloadData()
//        
//        guard let text, !text.isEmpty else {
//            input?.changeErrorVisibility(for: true)
//            return
//        }
//        
//        networkClient.fetch(
//            .search(
//                params: .init(request: text, entities: [.audiobook, .movie], limit: .firstLimit)
//            )
//        ) { [weak self] (result: Result<SearchResult, Error>) in
//            switch result {
//            case .success(let result):
//                self?.searchDataItemResults = result.results
//                self?.data = result.results.map { .result($0) }
//                DispatchQueue.main.async {
//                    self?.input?.changeErrorVisibility(for: false)
//                    self?.input?.reloadData()
//                }
//                
//            case .failure:
//                DispatchQueue.main.async {
//                    self?.input?.changeErrorVisibility(for: true)
//                }
//            }
//        }
//        
//        if !searchHistory.contains(text) {
//            if searchHistory.count == 5 {
//                searchHistory.removeFirst()
//            }
//            searchHistory.append(text)
//            saveHistory()
//        }
//    }
//    
//    func didSelectItem(at index: Int) {
//        guard let type = data.first else { return }
//        
//        switch type {
//        case .history:
//            processHistoryTapAction(index: index)
//            
//        case .result:
//            processResultTapAction(index: index)
//            
//        case .skeleton:
//            break
//        }
//    }
//    
//    private func processResultTapAction(index: Int) {
//        guard let searchDataItemResult = searchDataItemResults[safe: index] else { return }
//        
//        navigationDelegate?.searchDetailsPresenterDidRequestOpenDetailsFlow(
//            self,
//            viewModel: SearchDetailsViewModel(
//                artWorkUrl: searchDataItemResult.artworkUrl100,
//                trackName: searchDataItemResult.trackName ?? searchDataItemResult.collectionName,
//                artistName: searchDataItemResult.artistName,
//                kind: searchDataItemResult.kind ?? searchDataItemResult.wrapperType,
//                releaseDate: searchDataItemResult.releaseDate?.formatted(),
//                collectionName: searchDataItemResult.collectionName,
//                description: searchDataItemResult.description ?? searchDataItemResult.longDescription,
//                trackViewUrlString: searchDataItemResult.trackViewUrl,
//                artistId: searchDataItemResult.artistId
//                ?? searchDataItemResult.collectionId
//                ?? searchDataItemResult.trackId
//                ?? searchDataItemResult.collectionArtistId
//            ),
//            imagesProvider: imagesProvider
//        )
//    }
//    
//    private func processHistoryTapAction(index: Int) {
//        guard let historySearchResult = searchHistory.reversed()[safe: index] else { return }
//        input?.setupSearchText(historySearchResult)
//    }
//    
//    private func saveHistory() {
//        UserDefaults.standard.set(searchHistory, forKey: "history")
//    }
//    
//    private func readHistory() {
//        searchHistory = UserDefaults.standard.array(forKey: "history") as? [String] ?? []
//    }
//}
//
//extension Collection {
//    subscript (safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
