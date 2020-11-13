//
//  ArcadeVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 13/11/20.
//

import UIKit

class ArcadeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Configurations
extension ArcadeVC {
    
    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Arcade"
    }
}
