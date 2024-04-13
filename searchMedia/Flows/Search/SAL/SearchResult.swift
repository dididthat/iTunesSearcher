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
    
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistId: Int?
    let collectionArtistViewUrl: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let collectionPrice: Float?
    let trackPrice: Float?
    let trackRentalPrice: Float?
    let collectionHdPrice: Float?
    let trackHdPrice: Float?
    let trackHdRentalPrice: Float?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let longDescription: String?
    let hasITunesExtras: Bool?
    let isStreamable: Bool?
    let artistIds: [Int]?
    let genres: [String]?
    let price: Float?
    let genreIds: [String]?
    let description: String?
    let fileSizeBytes: Int?
    let formattedPrice: String?
    let averageUserRating: Float?
    let userRatingCount: Int?
    let copyright: String?
}
