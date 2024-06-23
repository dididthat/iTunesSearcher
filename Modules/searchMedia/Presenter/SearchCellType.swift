//
//  SearchCellType.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 21.06.2024.
//

import Foundation

enum SearchCellType {
    case history(String)
    case result(SearchResultItem)
    case skeleton
    
    var isHistory: Bool {
        switch self {
        case .history:
            return true
            
        case .result, .skeleton:
            return false
        }
    }
}
