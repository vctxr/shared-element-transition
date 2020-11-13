//
//  AppsVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 13/11/20.
//

import UIKit

class AppsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Configurations
extension AppsVC {
    
    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
    }
}
