//
//  Collection + Extensions.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 21.06.2024.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
