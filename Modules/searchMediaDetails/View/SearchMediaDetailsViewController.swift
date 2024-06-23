//
//  SearchMediaDetailsViewController.swift
//  searchMedia
//
//  Created by dvsnitsaryuk on 20.06.2024.
//

import UIKit

final class SearchMediaDetailsViewController:
    UIViewController,
    SearchMediaDetailsViewInput
{
    var loadImage: ((String?, @escaping (UIImage?) -> Void) -> Void)? {
        get { contentView.loadImage }
        set { contentView.loadImage = newValue }
    }
    var model: (() -> SearchDetailsViewModel?)? {
        get { contentView.model }
        set { contentView.model = newValue }
    }
    var hyperLinkDidTap: ((SearchDetailsHyperLinkType) -> Void?)? {
        get { contentView.hyperLinkDidTap }
        set { contentView.hyperLinkDidTap = newValue }
    }
    var onViewDidLoad: (() -> Void)?
    var onBackButtonTap: (() -> Void)?
    
    private lazy var contentView = SearchMediaDetailsView()
    private var disposables: [AnyObject] = []
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backAction = UIAction { [weak self] _ in
            self?.onBackButtonTap?()
        }
        navigationItem.title = model?()?.trackName
        
        onViewDidLoad?()
    }
    
    func addDisposable(_ object: AnyObject) {
        disposables.append(object)
    }
    
    func displayArtistInfo(_ model: SearchDetailsArtistModel) {
        contentView.displayArtistInfo(model)
    }
    
    func changeErrorVisibility(for isShown: Bool) {
        contentView.changeErrorVisibility(for: isShown)
    }
}
