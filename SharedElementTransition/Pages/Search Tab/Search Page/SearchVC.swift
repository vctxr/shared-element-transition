//
//  SearchVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 13/11/20.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Configurations
extension SearchVC {
    
    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
    }
}
