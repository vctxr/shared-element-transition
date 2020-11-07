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
        let todayView = TodayView()
        todayView.collectionView.delegate = self
        todayView.collectionView.dataSource = self
        todayView.frame = view.bounds
        return todayView
    }()
    
    private lazy var tabBar: UITabBar? = {
        return tabBarController?.tabBar
    }()
    
    lazy var originalTabBarFrame: CGRect? = {
        return tabBar?.frame
    }()
    
    private let sharedElementTransitionManager = SharedElementTransitionManager()
    private let appCards: [AppCard] = AppCard.getAppCards()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = todayView
    }
    
    // MARK: - Functions
    func getSelectedAppCardView() -> AppCardView? {
        guard let selectedIndexPath = todayView.collectionView.indexPathsForSelectedItems else { return nil }
        
        let cell = todayView.collectionView.cellForItem(at: selectedIndexPath[0]) as! AppCardCollectionCell
        return cell.appCardView
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
        
        cell.appCardView.appCard = appCard
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier, for: IndexPath(item: 0, section: 0)) as! TodayHeaderCollectionReusableView
        let headerViewHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        return CGSize(width: collectionView.frame.width, height: headerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayHeaderCollectionReusableView.identifier, for: indexPath) as! TodayHeaderCollectionReusableView
        let dateString = Date().formatCurrentDate(format: "EEEE d MMMM").uppercased()
        let profileImage = UIImage(named: "profile")
        
        headerView.configure(with: dateString, profileImage: profileImage)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAppCard = appCards[indexPath.row]
        let detailVC = DetailVC(appCard: selectedAppCard)
        detailVC.transitioningDelegate = sharedElementTransitionManager
        detailVC.modalPresentationStyle = .overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
}

