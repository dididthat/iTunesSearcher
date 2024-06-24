//
//  SearchMediaPresenterImpl.swift
//  searchMedia
//
//  Created by snydia on 20.06.2024.
//

import UIKit

final class SearchMediaPresenterImpl: SearchMediaPresenter {

    weak var view: SearchMediaViewInput? {
        didSet {
            setUpView()
        }
    }
    
    private let interactor: SearchMediaInteractor
    private let router: SearchMediaRouter
    private let imagesProvider: ImagesProvider
    private var data: [SearchCellType] = []
    private var searchHistory: [String]
    private var searchDataItemResults: [SearchResultItem] = []
    
    init(
        interactor: SearchMediaInteractor,
        router: SearchMediaRouter,
        imagesProvider: ImagesProvider
    ) {
        self.interactor = interactor
        self.router = router
        self.imagesProvider = imagesProvider
        self.searchHistory = interactor.readHistory()
    }
    
    func searchButtonDidTap(text: String?) {
        data = (1...10).map { _ in .skeleton }
        view?.switchState(to: .result)
        view?.reloadData()
        
        guard let text, !text.isEmpty else {
            view?.changeErrorVisibility(for: true)
            return
        }
        
        interactor.search(text: text) { [weak self] (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let result):
                self?.searchDataItemResults = result.results
                self?.data = result.results.map { .result($0) }
                DispatchQueue.main.async {
                    self?.view?.changeErrorVisibility(for: false)
                    self?.view?.reloadData()
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.changeErrorVisibility(for: true)
                }
            }
        }
        
        if !searchHistory.contains(text) {
            if searchHistory.count == 5 {
                searchHistory.removeFirst()
            }
            searchHistory.append(text)
            interactor.saveHistory(searchHistory: searchHistory)
        }
    }
    
    func update(text: String?) {
        guard let text else { return }
        
        if !text.isEmpty {
            data = searchHistory
                .filter { $0.lowercased().contains(text.lowercased()) }
                .map { .history($0) }
                .reversed()
        } else if data.first?.isHistory == true {
            data = searchHistory
                .map { .history($0) }
                .reversed()
        }
        view?.reloadData()
    }
    
    func searchBarDidFocus() {
        view?.changeErrorVisibility(for: false)
        data = searchHistory
            .map { .history($0) }
            .reversed()
        view?.switchState(to: .history)
        view?.reloadData()
    }
    
    func searchBarDidUnfocus() {
        guard !searchDataItemResults.isEmpty else { return }
        data = searchDataItemResults.map { .result($0) }
        view?.switchState(to: .result)
        view?.reloadData()
    }
    
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard
            let urlString,
            let url = URL(string: urlString)
        else {
            return
        }
        interactor.loadImage(for: url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func setUpView() {
        view?.numberOfItemsInSection = { [weak self] in
            self?.data.count ?? 0
        }
        
        view?.didSelectItem = { [weak self] in
            self?.didSelectItem(at: $0)
        }
        
        view?.updateText = { [weak self] in
            self?.update(text: $0)
        }
        
        view?.searchButtonDidTap = { [weak self] in
            self?.searchButtonDidTap(text: $0)
        }
        
        view?.searchBarDidFocus = { [weak self] in
            self?.searchBarDidFocus()
        }
        
        view?.searchBarDidUnFocus = { [weak self] in
            self?.searchBarDidUnfocus()
        }
        
        view?.typeForIndex = { [weak self] in
            self?.data[$0]
        }
        
        view?.loadImage = { [weak self] in
            self?.loadImage(for: $0, completion: $1)
        }
    }
    
    private func didSelectItem(at index: Int) {
        guard let type = data.first else { return }
        
        switch type {
        case .history:
            processHistoryTapAction(index: index)
            
        case .result:
            processResultTapAction(index: index)
            
        case .skeleton:
            break
        }
    }
    
    private func processHistoryTapAction(index: Int) {
        guard let historySearchResult = searchHistory.reversed()[safe: index] else { return }
        view?.setupSearchText(historySearchResult)
    }
    
    private func processResultTapAction(index: Int) {
        guard let searchDataItemResult = searchDataItemResults[safe: index] else { return }
        
        router.showDetails(
            viewModel: SearchDetailsViewModel(
                artWorkUrl: searchDataItemResult.artworkUrl100,
                trackName: searchDataItemResult.trackName ?? searchDataItemResult.collectionName,
                artistName: searchDataItemResult.artistName,
                kind: searchDataItemResult.kind ?? searchDataItemResult.wrapperType,
                releaseDate: searchDataItemResult.releaseDate?.formatted(),
                collectionName: searchDataItemResult.collectionName,
                description: searchDataItemResult.description ?? searchDataItemResult.longDescription,
                trackViewUrlString: searchDataItemResult.trackViewUrl,
                artistId: searchDataItemResult.artistId
                ?? searchDataItemResult.collectionId
                ?? searchDataItemResult.trackId
                ?? searchDataItemResult.collectionArtistId
            ),
            imagesProvider: imagesProvider
        )
    }
}
