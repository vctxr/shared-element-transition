//
//  AppCardCollectionCell.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

class AppCardCollectionCell: UICollectionViewCell {
    
    static let identifier = "AppCardCollectionCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Title and Subtitle
    lazy private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .semibold)
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
        label.numberOfLines = 0
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
    
    var appCard: AppCard? {
        didSet {
            setupUI()
        }
    }
    
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    func setupUI() {
        guard let appCard = appCard else { return }
        
        backgroundImageView.image = UIImage(named: appCard.imageName)
        
        switch appCard.type {
        case .appOfTheDay:
            removeViews(views: [titleStackView, descriptionLabel])
            configureBottomCTA(with: appCard)
            configureAppOfTheDay(with: appCard)
        case .highlight:
            removeViews(views: [appOfTheDayLabel, blurEffectView])
            configureTitleAndSubtitle(with: appCard)
            configureDescription(with: appCard)
        case .explore:
            removeViews(views: [appOfTheDayLabel, appIconImageView])
            configureTitleAndSubtitle(with: appCard)
            configureBottomCTA(with: appCard)
        }
    }
    
    private func removeViews(views: [UIView]) {
        views.forEach({ $0.removeFromSuperview() })
    }
}

// MARK: - Configurations
extension AppCardCollectionCell {
    
    private func configureAppOfTheDay(with appCard: AppCard) {
        contentView.addSubview(appOfTheDayLabel)
        
        NSLayoutConstraint.activate([
            appOfTheDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appOfTheDayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            appOfTheDayLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -20),
            appOfTheDayLabel.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        appOfTheDayLabel.text = appCard.largeTitle
        appOfTheDayLabel.setLineSpacing(lineHeightMultiple: 0.75)

        appOfTheDayLabel.textColor = appCard.backgroundType.bottom == .light ? .black : .white
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
        contentView.addSubview(blurEffectView)
        
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
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
        
        appNameLabel.textColor = appCard.backgroundType.bottom == .light ? .black : .white
        messageLabel.textColor = appCard.backgroundType.bottom == .light ? .gray : .white
        ctaButton.backgroundColor = appCard.backgroundType.bottom == .light ? .systemGray5 : .white
    }
    
    private func configureDescription(with appCard: AppCard) {
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        descriptionLabel.text = appCard.shortDescription
        descriptionLabel.textColor = appCard.backgroundType.bottom == .light ? .black : .white
    }
    
    private func configureTitleAndSubtitle(with appCard: AppCard) {
        contentView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(subtitleLabel)
        titleStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        subtitleLabel.text = appCard.subtitle
        titleLabel.text = appCard.title
        
        subtitleLabel.textColor = appCard.backgroundType.top[0] == .light ? .gray : .lightText
        titleLabel.textColor = appCard.backgroundType.top[1] == .light ? .black : .white
    }
    
    
    private func configureSubviews() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)
        
        configureShadow()
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 12)
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 5, dy: 0), cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
