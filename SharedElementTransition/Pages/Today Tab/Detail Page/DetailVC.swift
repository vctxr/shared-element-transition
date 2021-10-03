//
//  DetailVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

class DetailVC: UIViewController, AnimatableStatusBar {
    
    // MARK: - Status Bar Animation
    var statusBarShouldBeHidden: Bool = false
    var statusBarAnimationStyle: UIStatusBarAnimation = .slide
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarAnimationStyle
    }
        
    // The main view of this controller
    lazy var detailView: DetailView = {
        let detailView = DetailView(appCardView: appCardView)
        detailView.frame = view.bounds
        detailView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        detailView.scrollView.delegate = self
        return detailView
    }()
         
    private var isPullingToDismiss: Bool = false
    
    private let appCardView: AppCardView
    private let appCard: AppCard
    
    // MARK: - Inits
    init(appCard: AppCard) {
        self.appCard = appCard
        self.appCardView = AppCardView(appCard: appCard, appCardState: .expanded)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateStatusBarAppearance(hidden: true, duration: Constants.STATUS_BAR_TRANSITION_ANIMATION_DURATION)
    }
    
    // MARK: - Trait Collection Did Change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let yOffset = detailView.scrollView.contentOffset.y
            changeCloseButtonAppearance(basedOn: yOffset)
        }
    }
    
    // MARK: - Handlers
    @objc private func didTapCloseButton() {
        statusBarAnimationStyle = .fade
        animateStatusBarAppearance(hidden: false, duration: Constants.STATUS_BAR_TRANSITION_ANIMATION_DURATION) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Helper Functions
    func changeCloseButtonAppearance(basedOn yOffset: CGFloat) {
        // The treshold where the close button crosses from app card image to background color
        let tresholdOffset = Constants.APP_CARD_EXPANDED_HEIGHT - (Constants.APP_CARD_CLOSE_BUTTON_SIZE.height / 2) - 20
        
        if yOffset < tresholdOffset {
            switch appCard.backgroundAppearance.top {
            case .light:
                detailView.closeButton.animateAppearanceIfNeeded(for: .dark)
            case .dark:
                detailView.closeButton.animateAppearanceIfNeeded(for: .light)
            }
        } else {
            if isDarkMode {
                detailView.closeButton.animateAppearanceIfNeeded(for: .light)
            } else {
                detailView.closeButton.animateAppearanceIfNeeded(for: .dark)
            }
        }
    }
}

// MARK: - ScrollView Delegate
extension DetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // The initial top y offset is 0.0
        let yOffset = scrollView.contentOffset.y
        let yTranslation = scrollView.panGestureRecognizer.translation(in: view).y
        
        scrollView.showsVerticalScrollIndicator = yOffset <= 1 ? false : true
        
        // If going up and not tracking (no touch) then disable bounce, otherwise enable bounce
        if yTranslation > 0 && !scrollView.isTracking {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
        
        changeCloseButtonAppearance(basedOn: yOffset)
        
        if yOffset < 0 && scrollView.isTracking {
            detailView.createSnapshotOfViewIfNeeded()
            
            isPullingToDismiss = true
            detailView.isSnapshotShowing = true
            
            let dismissTreshold = Constants.DISMISS_TRESHOLD
            let minScale = Constants.MIN_SCALE
            let maxCornerRadius = Constants.APP_CARD_CORNER_RADIUS
            let maxCloseButtonAlpha = Constants.APP_CARD_CLOSE_BUTTON_ALPHA
            
            // Scale ranging from 1 to 0.85 at yOffset = -100
            let scale = 1 - (yOffset / -dismissTreshold ) * (1 - minScale)

            // Corner radius ranging from 0 to 10 at yOffset = -100
            let cornerRadius = maxCornerRadius - ((yOffset + dismissTreshold) / dismissTreshold) * maxCornerRadius
            
            // Close button alpha ranging from 0.9 to 0 at yOffset = -100
            let alpha = maxCloseButtonAlpha - (yOffset / -dismissTreshold) * maxCloseButtonAlpha
            
            detailView.snapshotImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            detailView.snapshotImageView.layer.cornerRadius = cornerRadius
            detailView.closeButtonCopy?.alpha = alpha
            
            if yOffset <= -dismissTreshold {
                isPullingToDismiss = false
                didTapCloseButton()
            }
        } else {
            if isPullingToDismiss {
                isPullingToDismiss = false
                
                if scrollView.contentOffset.y >= 0 {
                    detailView.isSnapshotShowing = false
                } else {
                    let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
                        self.detailView.snapshotImageView.transform = .identity
                    }
                    
                    animator.addCompletion { (_) in
                        self.detailView.isSnapshotShowing = false
                    }
                    animator.startAnimation()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.bounces = true
    }
}
