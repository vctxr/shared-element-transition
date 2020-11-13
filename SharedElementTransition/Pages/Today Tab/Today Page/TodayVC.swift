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
    
    private lazy var safeAreaTopInset: CGFloat = {
        return UIDevice.current.safeAreaTopHeight
    }()
    
    private lazy var topScrollOffset = {
        // The initial top y offset is -(safe area top inset - 20) (because issue in notchless iphones)
        return -(safeAreaTopInset - 20)
    }()
            
    private let sharedElementTransitionManager = SharedElementTransitionManager()
    private let appCards: [AppCard] = AppCard.getAppCards()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = todayView
        tabBarController?.delegate = self
    }
    
    // MARK: - Functions
    func getSelectedAppCardView() -> AppCardView? {
        guard let selectedIndexPath = todayView.collectionView.indexPathsForSelectedItems?.first else { return nil }
        
        let cell = todayView.collectionView.cellForItem(at: selectedIndexPath) as! AppCardCollectionCell
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
        cell.appCardView.indexPath = indexPath
        cell.appCardView.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: Constants.APP_CARD_HEIGHT)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
                
        if yOffset <= topScrollOffset + 12 {
            let alpha = 1 + ((yOffset - (topScrollOffset + 12)) / 12 ) * 1
            todayView.statusBarBlurView.alpha = max(0, alpha)
        } else {
            todayView.statusBarBlurView.alpha = 1
        }
    }
}

// MARK: - AppCardView Delegate
extension TodayVC: AppCardViewDelegate {
    
    func didTapAppCardView(with appCard: AppCard, at indexPath: IndexPath) {
        todayView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        
        let detailVC = DetailVC(appCard: appCard)
        detailVC.transitioningDelegate = sharedElementTransitionManager
        detailVC.modalPresentationStyle = .overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
}


// MARK: - TabBarController Delegate
extension TodayVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedIndex == 0 && viewController == self {
            todayView.collectionView.setContentOffset(CGPoint(x: 0, y: topScrollOffset), animated: true)
        }
        return true
    }
}

