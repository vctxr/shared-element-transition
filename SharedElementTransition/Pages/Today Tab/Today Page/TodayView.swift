//
//  MainView.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

class TodayView: UIView {
    
    let statusBarBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 35
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AppCardCollectionCell.self, forCellWithReuseIdentifier: AppCardCollectionCell.identifier)
        collectionView.register(TodayHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .none
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        collectionView.delaysContentTouches = false
        return collectionView
    }()
        
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if statusBarBlurView.superview != self {
            configureStatusBarBlurView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configurations
extension TodayView {
    
    private func configureSubviews() {
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureStatusBarBlurView() {
        addSubview(statusBarBlurView)
        
        NSLayoutConstraint.activate([
            statusBarBlurView.topAnchor.constraint(equalTo: topAnchor),
            statusBarBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusBarBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            statusBarBlurView.heightAnchor.constraint(equalToConstant: UIDevice.current.safeAreaTopHeight)
        ])
    }
}
