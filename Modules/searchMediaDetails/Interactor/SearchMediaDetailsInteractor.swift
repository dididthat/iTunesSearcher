//
//  SearchMediaDetailsInteractor.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

protocol SearchMediaDetailsInteractor: AnyObject {
    func searchArtist(id: Int, completion:  @escaping (Result<SearchDetailsArtistDTO, Error>) -> Void) 
    func loadImage(for urlString: String?, completion: @escaping (UIImage?) -> Void)
}
