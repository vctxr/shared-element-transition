//
//  AppCardCollectionCell.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

class AppCardCollectionCell: UICollectionViewCell {
    
    static let identifier = "AppCardCollectionCell"
    
    let appCardView = AppCardView()
    
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configurations
extension AppCardCollectionCell {
    
    private func configureSubviews() {        
        appCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appCardView)

        NSLayoutConstraint.activate([
            appCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            appCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            appCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            appCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
