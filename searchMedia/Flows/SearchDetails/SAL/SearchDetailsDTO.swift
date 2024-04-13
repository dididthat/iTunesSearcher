//
//  SearchDetailsDTO.swift
//  searchMedia
//
//  Created by snydia on 13.04.2024.
//

import Foundation

struct SearchDetailsArtistDTO: Decodable {
    let results: [ArtistResultDTO]
}

struct ArtistResultDTO: Decodable {
    let wrapperType: String?
    let artistType: String?
    let artistName: String?
    let artistLinkUrl: String?
    let artistViewUrl: String?
    let trackViewUrl: String?
    let artistId: Int?
    let amgArtistId: Int?
    let primaryGenreName: String?
    let primaryGenreId: Int?
}

extension NetworkAPI {
    static func searchArtist(id: Int) -> NetworkAPI {
        return NetworkAPI(
            path: "/lookup",
            method: .getWithQueryParams([
                "id": String(id),
            ])
        )
    }
}
