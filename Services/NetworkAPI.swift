//
//  NetworkAPI.swift
//  searchMedia
//
//  Created by snydia on 12.04.2024.
//

import Foundation

struct NetworkAPI {
    let path: String
    let method: NetworkMethod
}

enum NetworkMethod {
    case getWithQueryParams([String: String])
}
