//
//  SearchParams.swift
//  searchMedia
//
//  Created by snydia on 12.04.2024.
//

import Foundation

struct SearchParams {
    let request: String
    let entities: [EntityType]
    let limit: EntityType.Limit
}

enum EntityType: String, CaseIterable {
    case movie
    case audiobook
    case song
    
    enum Image: String {
        case movie = "film.circle.fill"
        case audiobook = "book.circle.fill"
        case song = "music.mic.circle.fill"
    }
    
    enum Limit: Int, CaseIterable {
        case firstLimit = 30
        case secondLimit = 40
        case thirdLimit = 50
    }
}

extension NetworkAPI {
    static func search(params: SearchParams) -> NetworkAPI {
        return NetworkAPI(
            path: "/search",
            method: .getWithQueryParams([
                "term": params.request,
                "entity": params.entities.map { $0.rawValue }.joined(separator: ","),
                "limit": String(params.limit.rawValue),
                "country": "us"
            ])
        )
    }
}
