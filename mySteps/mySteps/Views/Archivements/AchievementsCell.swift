//
//  AchievementsCell.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit

class AchievementsCell: UITableViewCell {
    
    // MARK: - Properties
    
    let viewModel: AchievementsCellViewModel

    // MARK: - Views
    let stepsLabel = UILabel()
    let dateLabel = UILabel()
    let achievementsImageView = UIImageView()

    // MARK: - Init

    init(viewModel: AchievementsCellViewModel, style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        self.viewModel = viewModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with viewModel: AchievementsCellViewModel) {
        // Configure the views with data from the viewModel
        stepsLabel.text = "\(Int(viewModel.steps)) Steps"
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
        
        // This will make the image view circular
        achievementsImageView.layer.cornerRadius = viewModel.width / 2 // Half of the width to make it a circle
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
            // Image constraints
            achievementsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            achievementsImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            achievementsImageView.widthAnchor.constraint(equalToConstant: viewModel.width),
            achievementsImageView.heightAnchor.constraint(equalToConstant: viewModel.width),
            
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

