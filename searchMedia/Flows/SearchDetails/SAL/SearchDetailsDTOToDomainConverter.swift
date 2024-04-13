//
//  SearchDetailsDTOToDomainConverter.swift
//  searchMedia
//
//  Created by snydia on 13.04.2024.
//

import Foundation

struct SearchDetailsArtistDTOToDomainConverter{
    func convert(from value: ArtistResultDTO) -> SearchDetailsArtistModel? {
        return SearchDetailsArtistModel(
            wrapperType: value.wrapperType,
            artistType: value.artistType,
            artistName: value.artistName,
            artistLinkUrl: value.artistLinkUrl,
            artistViewUrl: value.artistViewUrl,
            trackViewUrl: value.trackViewUrl,
            primaryGenreName: value.primaryGenreName
        )
    }
}
