//
//  ViewController.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

class TodayVC: UIViewController {
    
    // The main view of this controller
    private lazy var todayView: TodayView = {
        let mainView = TodayView()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.frame = view.bounds
        return mainView
    }()
    
    private let appCards: [AppCard] = AppCard.getAppCards()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}


// MARK: - CollectionView Delegate and Data Source
extension TodayVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCardCollectionCell.identifier, for: indexPath) as! AppCardCollectionCell
        let appCard = appCards[indexPath.row]
        cell.appCard = appCard
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - (20 * 2), height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier, for: IndexPath(item: 0, section: 0)) as! TodayHeaderCollectionReusableView
        let headerViewHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return CGSize(width: collectionView.frame.width, height: headerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier, for: indexPath) as! TodayHeaderCollectionReusableView
        let dateString = Date().formatCurrentDate(format: "EEEE d MMMM")
        headerView.configure(with: dateString.uppercased())
        return headerView
    }
}


// MARK: - Configurations
extension TodayVC {
    
    private func configureSubviews() {
        view = todayView
    }
}

