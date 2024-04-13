//
//  SearchResult.swift
//  searchMedia
//
//  Created by snydia on 12.04.2024.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [SearchResultItem]
}

struct SearchResultItem: Codable {
    let wrapperType: String
    let kind: String?
    let artworkUrl100: String?
    
    let artistName: String?
    let releaseDate: Date?
    
    let trackName: String?
    
    let collectionName: String?
}
