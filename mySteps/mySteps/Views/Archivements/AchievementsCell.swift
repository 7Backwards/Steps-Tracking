//
//  AchievementsCell.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit

class AchievementsCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: AchievementsCellViewModel?
    let imageViewSize: CGFloat = 116.0

    // MARK: - Views
    let stepsLabel = UILabel()
    let dateLabel = UILabel()
    let achievementsImageView = UIImageView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with viewModel: AchievementsCellViewModel) {
        self.viewModel = viewModel
        // Configure the views with data from the viewModel
        stepsLabel.text = viewModel.steps
        dateLabel.text = viewModel.formattedDate
        achievementsImageView.image = viewModel.image
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {

        // Image setup
        achievementsImageView.contentMode = .scaleAspectFill
        achievementsImageView.clipsToBounds = true
        achievementsImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(achievementsImageView)
        
        achievementsImageView.layer.cornerRadius = imageViewSize / 2 // Half of the width to make it a circle
        achievementsImageView.layer.masksToBounds = true
        
        stepsLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepsLabel)
        
        // Date label setup
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        dateLabel.alpha = 0.5
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // Setup Image constraints
            achievementsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            achievementsImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            achievementsImageView.widthAnchor.constraint(equalToConstant: imageViewSize),
            achievementsImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            
            // Steps label constraints
            stepsLabel.topAnchor.constraint(equalTo: achievementsImageView.bottomAnchor, constant: 8),
            stepsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Date label constraints
            dateLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


