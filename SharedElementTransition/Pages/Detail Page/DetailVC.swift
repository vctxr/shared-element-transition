//
//  DetailVC.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

class DetailVC: UIViewController, StatusBarAnimation {
    
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
        if yOffset < Constants.APP_CARD_EXPANDED_HEIGHT - (Constants.APP_CARD_CLOSE_BUTTON_SIZE.height / 2) - 20 {
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
        let yOffset = scrollView.contentOffset.y
        changeCloseButtonAppearance(basedOn: yOffset)
    }
}
