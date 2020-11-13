//
//  GamesVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 13/11/20.
//

import UIKit

class GamesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Configurations
extension GamesVC {
    
    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Games"
    }
}
