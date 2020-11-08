//
//  AppCardView.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 02/11/20.
//

import UIKit

protocol AppCardViewDelegate: AnyObject {
    func didTapAppCardView(with appCard: AppCard, at indexPath: IndexPath)
}

enum AppCardState {
    case card
    case expanded
}

class AppCardView: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.APP_CARD_CORNER_RADIUS
        view.clipsToBounds = true
        return view
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Constants.APP_CARD_SHADOW_OPACITY
        view.layer.shadowRadius = Constants.APP_CARD_SHADOW_RADIUS
        view.layer.shadowOffset = Constants.APP_CARD_SHADOW_OFFSET
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: - Title and Subtitle
    lazy private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .bold)
        label.applyDynamicType()
        return label
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.numberOfLines = 0
        label.applyDynamicType()
        return label
    }()
    
    lazy private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    // MARK: - Description
    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.applyDynamicType()
        return label
    }()
    
    // MARK: - App of The Day
    lazy private var appOfTheDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 45, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Bottom CTA
    lazy private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    lazy private var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline).with(weight: .medium)
        label.numberOfLines = 0
        label.applyDynamicType()
        return label
    }()
    
    lazy private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.applyDynamicType()
        return label
    }()
    
    lazy private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    lazy private var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    lazy private var ctaButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.layer.cornerRadius = 14
        return button
    }()
        
    weak var delegate: AppCardViewDelegate?
    
    // MARK: - Layout Constraints
    var topTitleConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?

    private var appCardState: AppCardState = .card
    
    var isTapGestureAdded: Bool = false
    var indexPath: IndexPath?
    
    var appCard: AppCard! {
        didSet {
            configureSubviews(with: appCard)
        }
    }
    
    // MARK: - Inits
    init(appCard: AppCard, appCardState: AppCardState) {
        self.appCard = appCard
        self.appCardState = appCardState
        
        super.init(frame: .zero)
        configureSubviews(with: appCard)
    }
    
    // Empty init -> no app card model injected
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds.insetBy(dx: 5, dy: 0), cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    // MARK: - Handlers
    @objc private func didTapAppCardViewContainer() {
        guard let indexPath = indexPath else { return }
        delegate?.didTapAppCardView(with: appCard, at: indexPath)
    }
    
    // MARK: - Functions
    func updateLayout(for appCardState: AppCardState) {
        self.appCardState = appCardState
        
        switch appCardState {
        case .card:
            topTitleConstraint?.constant = 16
            leadingConstraint?.constant = 20
            trailingConstraint?.constant = -20
            
            containerView.layer.cornerRadius = Constants.APP_CARD_CORNER_RADIUS
            
            shadowView.showAllShadows(opacity: Constants.APP_CARD_SHADOW_OPACITY, radius: Constants.APP_CARD_SHADOW_RADIUS, offset: Constants.APP_CARD_SHADOW_OFFSET)
        case .expanded:
            topTitleConstraint?.constant = max(20, UIDevice.current.safeAreaTopHeight)
            leadingConstraint?.constant = 0
            trailingConstraint?.constant = 0
            
            containerView.layer.cornerRadius = 0

            shadowView.hideAllShadows()
        }
    }
    
    private func addTapGestureToContainerViewIfNeeded() {
        if !isTapGestureAdded {
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAppCardViewContainer)))
            isTapGestureAdded = true
        }
    }
}

// MARK: - Configurations
extension AppCardView {
    
    private func configureSubviews(with appCard: AppCard) {
        addTapGestureToContainerViewIfNeeded()
        
        addSubview(shadowView)
        addSubview(containerView)
        
        backgroundImageView.image = UIImage(named: appCard.imageName)
        containerView.addSubview(backgroundImageView)
        
        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        trailingConstraint = containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
                
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            leadingConstraint!,
            trailingConstraint!,
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
                
        switch appCard.type {
        case .appOfTheDay:
            removeViewsFromSuperview(views: [titleStackView, descriptionLabel])
            configureBottomCTA(with: appCard)
            configureAppOfTheDay(with: appCard)
        case .highlight:
            removeViewsFromSuperview(views: [appOfTheDayLabel, blurEffectView])
            configureTitleAndSubtitle(with: appCard)
            configureDescription(with: appCard)
        case .explore:
            removeViewsFromSuperview(views: [appOfTheDayLabel, appIconImageView])
            configureTitleAndSubtitle(with: appCard)
            configureBottomCTA(with: appCard)
        }
        
        updateLayout(for: appCardState)
    }
    
    private func configureAppOfTheDay(with appCard: AppCard) {
        containerView.addSubview(appOfTheDayLabel)
        
        NSLayoutConstraint.activate([
            appOfTheDayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            appOfTheDayLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20),
            appOfTheDayLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -20),
            appOfTheDayLabel.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        appOfTheDayLabel.text = appCard.largeTitle
        appOfTheDayLabel.applyLineSpacing(lineHeightMultiple: 0.75)
        

        appOfTheDayLabel.textColor = appCard.backgroundAppearance.bottom == .light ? .black : .white
    }
    
    private func configureBottomCTA(with appCard: AppCard) {
        verticalStackView.addArrangedSubview(appNameLabel)
        verticalStackView.addArrangedSubview(messageLabel)
        
        if let appIconImageName = appCard.appIconName {
            horizontalStackView.addArrangedSubview(appIconImageView)
            appIconImageView.image = UIImage(named: appIconImageName)
            
            NSLayoutConstraint.activate([
                appIconImageView.widthAnchor.constraint(equalToConstant: 50),
                appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor)
            ])
        }
        
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        blurEffectView.contentView.addSubview(horizontalStackView)
        blurEffectView.contentView.addSubview(ctaButton)
        containerView.addSubview(blurEffectView)
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            horizontalStackView.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: ctaButton.leadingAnchor, constant: -20),
            horizontalStackView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16),
            
            ctaButton.heightAnchor.constraint(equalToConstant: 28),
            ctaButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            ctaButton.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor),
            ctaButton.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -20),
            
        ])
        
        appNameLabel.text = appCard.appName
        messageLabel.text = appCard.message
        
        if appCard.type == .explore {
            ctaButton.setTitle("EXPLORE", for: .normal)
        } else {
            ctaButton.setTitle("GET", for: .normal)
        }
        
        appNameLabel.textColor = appCard.backgroundAppearance.bottom == .light ? .black : .white
        messageLabel.textColor = appCard.backgroundAppearance.bottom == .light ? .gray : .white
        ctaButton.backgroundColor = appCard.backgroundAppearance.bottom == .light ? .lightText : .white
    }
    
    private func configureTitleAndSubtitle(with appCard: AppCard) {
        containerView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(subtitleLabel)
        titleStackView.addArrangedSubview(titleLabel)
        
        topTitleConstraint = titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        NSLayoutConstraint.activate([
            topTitleConstraint!,
            titleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        subtitleLabel.text = appCard.subtitle
        titleLabel.text = appCard.title
        
        subtitleLabel.textColor = appCard.backgroundAppearance.top == .light ? .gray : .lightText
        titleLabel.textColor = appCard.backgroundAppearance.top == .light ? .black : .white
    }
    
    private func configureDescription(with appCard: AppCard) {
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        descriptionLabel.text = appCard.shortDescription
        descriptionLabel.textColor = appCard.backgroundAppearance.bottom == .light ? .black : .white
    }
}
