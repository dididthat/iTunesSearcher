//
//  SearchMediaDetailsViewInput.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

protocol SearchMediaDetailsViewInput: AnyObject {
    var model: (() -> SearchDetailsViewModel?)?  { get set }
    var loadImage: ((String?, @escaping (UIImage?) -> Void) -> Void)? { get set }
    var hyperLinkDidTap: ((SearchDetailsHyperLinkType) -> Void?)? { get set }
    var onBackButtonTap: (() -> ())? { get set }
    var onViewDidLoad: (() -> Void)? { get set }
    func displayArtistInfo(_ model: SearchDetailsArtistModel)
    func changeErrorVisibility(for isShown: Bool)
}
