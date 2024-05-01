//
//  AchievementViewController.swift
//  mySteps
//
//  Created by Gonçalo on 29/04/2024.
//

import UIKit

class AchievementViewController: UIViewController, CustomBackButtonProtocol {
    
    // MARK: - Properties

    let achievement: Achievement
    let achievementView = AchievementView(frame: .zero, imageViewSize: 208, stepsLabelTextSize: 32, dateLabelTextSize: 24)

    // MARK: - Init

    init(achievement: Achievement) {
        self.achievement = achievement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        setupCustomBackButton()
        configureNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        // Set the title
        title = NSLocalizedString("achievement", comment: "")

        // Define the attributes for the title
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .black)
        ]
        
        // Apply the attributes to the navigation bar title
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground

        let viewModel = AchievementsViewModel(achievement: achievement)
        achievementView.configure(with: viewModel)
    }
    
    private func setupConstraints() {
        achievementView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(achievementView)
        
        NSLayoutConstraint.activate([
            achievementView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            achievementView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
