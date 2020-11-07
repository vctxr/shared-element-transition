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
        detailView.appCardView.translatesAutoresizingMaskIntoConstraints = false
        detailView.appCardView.containerView.layer.cornerRadius = 0
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
    
    // MARK: - Handlers
    @objc private func didTapCloseButton() {
        statusBarAnimationStyle = .none
        animateStatusBarAppearance(hidden: false, duration: 0) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
