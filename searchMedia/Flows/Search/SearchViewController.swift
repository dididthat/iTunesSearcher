//
//  SearchViewController.swift
//  searchMedia
//
//  Created by snydia on 10.04.2024.
//

import UIKit

protocol SearchFlowInput: AnyObject {
    
}

final class SearchViewController: UIViewController {
    private let output: SearchFlowOutput
    
    init(output: SearchFlowOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

extension SearchViewController: SearchFlowInput {
    
}
