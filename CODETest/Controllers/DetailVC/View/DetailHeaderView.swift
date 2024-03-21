//
//  DetailHeaderView.swift
//  CODETest
//
//  Created by Кристина Пастухова on 21.03.2024.
//

import UIKit

// Custom UIView to display user profile
class DetailHeaderView: UIView {
    
    // UI Components
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let tagLabel = UILabel()
    private let jobTitleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    // Horizontal stack view to hold the name and tag labels
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    
    // Custom initializer with parameters to set up the view
    init(frame: CGRect, profileImage: UIImage, name: String, tag: String, jobTitle: String) {
        super.init(frame: frame)
        setupView()
        configure(with: profileImage, name: name, tag: tag, jobTitle: jobTitle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }


    
    private func setupView() {
        self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = Constant.blackColor
        nameLabel.textAlignment = .center
        
        tagLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tagLabel.textColor = Constant.ligthGreyColor
        tagLabel.textAlignment = .center
        
        jobTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        jobTitleLabel.textColor = Constant.greyColor
        jobTitleLabel.textAlignment = .center
        
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 52
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        

        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 4
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(tagLabel)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 12
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(jobTitleLabel)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        

        backButton.setImage(UIImage(systemName: "back.button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        

        addSubview(profileImageView)
        addSubview(verticalStackView)
        

        setupConstraints()
    }
    
    private func configure(with profileImage: UIImage, name: String, tag: String, jobTitle: String) {
        profileImageView.image = profileImage
        nameLabel.text = name
        tagLabel.text = tag
        jobTitleLabel.text = jobTitle
    }
    
    private func setupConstraints() {
        // Define constraints for subviews
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 72),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 104),
            profileImageView.heightAnchor.constraint(equalToConstant: 104),
            
            verticalStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            verticalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
        
            
            
//            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
//            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
        ])
    }
    
    @objc private func backButtonTapped() {
        // Handle back button tap
        print("Back button tapped")
    }
}

