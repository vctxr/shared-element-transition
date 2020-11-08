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
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. \n\nLorem Ipsum comes from sections 1.10.32 and 1.10.33 of 'de Finibus Bonorum et Malorum' (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, 'Lorem ipsum dolor sit amet..', comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from 'de Finibus Bonorum et Malorum' by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham. Where can I get some? There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
        label.textColor = .secondaryLabel
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
        closeButton.isHidden = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset.y = 0
        let snapshotImage = createSnapshot()
        scrollView.showsVerticalScrollIndicator = true
        closeButton.isHidden = false
        
        snapshotImageView.image = snapshotImage
        snapshotImageView.frame = self.bounds
        
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
