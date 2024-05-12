//
//  AchievementsCell.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit

class AchievementsCell: UICollectionViewCell {

    // MARK: - Views

    let achievementsView: AchievementView = AchievementView(frame: .zero, imageViewSize: 116, stepsLabelTextSize: 16, dateLabelTextSize: 13)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with viewModel: AchievementsViewModel) {
        // Configure the views with data from the viewModel
        achievementsView.configure(with: viewModel)
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        addSubview(achievementsView)
        achievementsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            achievementsView.heightAnchor.constraint(equalToConstant: frame.height),
            achievementsView.widthAnchor.constraint(equalToConstant: frame.width)
        ])
    }
}


