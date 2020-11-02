//
//  DetailView.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

class DetailView: UIView {
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var appCardView: AppCardView

    
    // MARK: - Inits
    init(appCardView: AppCardView) {
        self.appCardView = appCardView
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configurations
extension DetailView {
    
    private func configureSubviews() {
        backgroundColor = .systemBackground
        appCardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(appCardView)
        addSubview(closeButton)
        
        appCardView.configureContainer(for: .full)
        
        NSLayoutConstraint.activate([
            appCardView.topAnchor.constraint(equalTo: topAnchor),
            appCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            appCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            appCardView.heightAnchor.constraint(equalToConstant: 450),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
