//
//  AchievementView.swift
//  mySteps
//
//  Created by Gonçalo on 29/04/2024.
//

import UIKit

class AchievementView: UIView {
    
    // MARK: - Properties

    var viewModel: AchievementsViewModel?
    let imageViewSize: CGFloat
    let stepsLabelTextSize: CGFloat
    let dateLabelTextSize: CGFloat
    
    // MARK: - Views

    let stepsLabel = UILabel()
    let dateLabel = UILabel()
    let achievementsImageView = UIImageView()

    
    init(frame: CGRect, imageViewSize: CGFloat, stepsLabelTextSize: CGFloat, dateLabelTextSize: CGFloat) {
        self.imageViewSize = imageViewSize
        self.stepsLabelTextSize = stepsLabelTextSize
        self.dateLabelTextSize = dateLabelTextSize

        super.init(frame: frame)
        
        configureViews()
    }
    
    func configure(with viewModel: AchievementsViewModel) {
        self.viewModel = viewModel
        // Configure the views with data from the viewModel
        stepsLabel.text = viewModel.achievement.formattedStepsString
        dateLabel.text = viewModel.formattedDate
        achievementsImageView.image = viewModel.achievement.image
    }
    
    private func configureViews() {

        // Image setup
        achievementsImageView.contentMode = .scaleAspectFill
        achievementsImageView.clipsToBounds = true
        achievementsImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(achievementsImageView)
        
        achievementsImageView.layer.cornerRadius = imageViewSize / 2 // Half of the width to make it a circle
        achievementsImageView.layer.masksToBounds = true
        
        stepsLabel.font = UIFont.systemFont(ofSize: stepsLabelTextSize, weight: .heavy)
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stepsLabel)
        
        // Date label setup
        dateLabel.font = UIFont.systemFont(ofSize: dateLabelTextSize, weight: .semibold)
        dateLabel.alpha = 0.5
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // Setup Image constraints
            achievementsImageView.topAnchor.constraint(equalTo: topAnchor),
            achievementsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            achievementsImageView.widthAnchor.constraint(equalToConstant: imageViewSize),
            achievementsImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            
            // Steps label constraints
            stepsLabel.topAnchor.constraint(equalTo: achievementsImageView.bottomAnchor, constant: 8),
            stepsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Date label constraints
            dateLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
