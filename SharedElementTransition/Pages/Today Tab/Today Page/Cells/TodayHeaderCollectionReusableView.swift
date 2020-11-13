//
//  TodayHeaderCollectionReusableView.swift
//  SharedElementTransition
//
//  Created by Victor Samuel Cuaca on 01/11/20.
//

import UIKit

class TodayHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "TodayHeaderCollectionReusableView"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .footnote).with(weight: .medium)
        label.applyDynamicType()
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
        label.applyDynamicType()
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    func configure(with dateString: String, profileImage: UIImage?) {
        dateLabel.text = dateString
        profileImageView.image = profileImage
    }
}


// MARK: - Configurations
extension TodayHeaderCollectionReusableView {
    
    private func configureSubviews() {
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(profileImageView)
        
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        addSubview(verticalStackView)
        
        let verticalStackBottomConstraint = verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        verticalStackBottomConstraint.priority = .defaultHigh
        
        let verticalStackTrailingConstraint = verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        verticalStackTrailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verticalStackTrailingConstraint,
            verticalStackBottomConstraint
        ])
    }
}
