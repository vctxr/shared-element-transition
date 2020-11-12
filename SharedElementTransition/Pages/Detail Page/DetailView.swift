//
//  DetailView.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

class DetailView: UIView {
    
    let closeButton: CloseButton = {
        let button = CloseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delaysContentTouches = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.applyDynamicType()
        return label
    }()
    
    lazy var snapshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    var closeButtonCopy: CloseButton?
    
    var isSnapshotShowing: Bool = false {
        didSet {
            closeButton.isHidden = isSnapshotShowing
            appCardView.isHidden = isSnapshotShowing
            textLabel.isHidden = isSnapshotShowing
            snapshotImageView.isHidden = !isSnapshotShowing
            
            scrollView.showsVerticalScrollIndicator = !isSnapshotShowing
            
            backgroundColor = isSnapshotShowing ? .clear : .systemBackground
        }
    }
    
    var isSnapshotNeeded: Bool = true
    
    let appCardView: AppCardView
    
    // MARK: - Inits
    init(appCardView: AppCardView) {
        self.appCardView = appCardView
        self.textLabel.text = appCardView.appCard.longDescription
        self.textLabel.applyLeadingBoldAttribute(separatedBy: "*")
        self.textLabel.applyLineSpacing(lineSpacing: 2)

        super.init(frame: .zero)
        
        configureSubviews()
        configureCloseButtonColor()
        configureScrollIndicatorInsets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Trait Collection Did Change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            isSnapshotNeeded = true
        }
    }
    
    // MARK: - Helper Functions
    func createSnapshotOfViewIfNeeded() {
        guard isSnapshotNeeded else { return }
        
        isSnapshotNeeded = !isSnapshotNeeded
        
        // Hides close button and scroll indicator before taking snapshot, also make sure scroll offset is 0 (top of the scroll)
        closeButton.isHidden = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset.y = 0
        
        let snapshotImage = createSnapshot()
        
        // Unhides close button and scroll indicator
        closeButton.isHidden = false
        scrollView.showsVerticalScrollIndicator = true
        
        snapshotImageView.image = snapshotImage
        snapshotImageView.frame = self.bounds
        
        // Need to create a close button copy and add it to the snapshot's subview so we can animate the close button copy alpha
        closeButtonCopy = closeButton.createCopy()
        snapshotImageView.addSubview(closeButtonCopy!)
        
        NSLayoutConstraint.activate([
            closeButtonCopy!.widthAnchor.constraint(equalToConstant: Constants.APP_CARD_CLOSE_BUTTON_SIZE.width),
            closeButtonCopy!.heightAnchor.constraint(equalTo: closeButtonCopy!.widthAnchor),
            closeButtonCopy!.topAnchor.constraint(equalTo: snapshotImageView.topAnchor, constant: 20),
            closeButtonCopy!.trailingAnchor.constraint(equalTo: snapshotImageView.trailingAnchor, constant: -20),
        ])
        
        addSubview(snapshotImageView)        
    }
}

// MARK: - Configurations
extension DetailView {
    
    private func configureCloseButtonColor() {
        switch appCardView.appCard.backgroundAppearance.top {
        case .light:
            closeButton.setInitialAppearance(appearance: .dark)
        case .dark:
            closeButton.setInitialAppearance(appearance: .light)
        }
    }
    
    func configureScrollIndicatorInsets() {
        let topInset = UIDevice.current.hasNotch ? Constants.APP_CARD_EXPANDED_HEIGHT - UIDevice.current.safeAreaTopHeight :
                                                   Constants.APP_CARD_EXPANDED_HEIGHT
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    private func configureSubviews() {
        backgroundColor = .systemBackground
        
        appCardView.translatesAutoresizingMaskIntoConstraints = false
        appCardView.containerView.layer.cornerRadius = 0
                
        addSubview(scrollView)
        addSubview(closeButton)
        
        scrollView.addSubview(appCardView)
        scrollView.addSubview(textLabel)
        
        let textLabelBottomConstant = UIDevice.current.safeAreaBottomHeight + 20
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: Constants.APP_CARD_CLOSE_BUTTON_SIZE.width),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            appCardView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            appCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            appCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            appCardView.heightAnchor.constraint(equalToConstant: Constants.APP_CARD_EXPANDED_HEIGHT),
            
            textLabel.topAnchor.constraint(equalTo: appCardView.bottomAnchor, constant: 40),
            textLabel.leadingAnchor.constraint(equalTo: appCardView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: appCardView.trailingAnchor, constant: -20),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -textLabelBottomConstant),
        ])
    }
}
