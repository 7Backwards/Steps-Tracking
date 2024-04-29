//
//  HomeViewController.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Properties methods
    
    private let viewModel: HomeViewModel
    private var subscriptions: [AnyCancellable] = []
    private let profilePictureSize: CGFloat = 180
    private let backgroundSize: CGFloat = 360
    private let horizontalMargin: CGFloat = 24
    
    // MARK: - Views
    
    private let profilePhotoBackground = UIImageView()
    private let stepsTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let stepsCountLabel = UILabel()
    private let achievementsLabel = UILabel()
    private let profileImageView = UIImageView()
    private let profilePictureZStackView = UIView()
    private let verticalStackView = UIStackView()
    private let stepsCountAndDateStackView = UIStackView()
    private let achievementsCollectionView = AchievementsCollectionView(viewModel: AchievementsCollectionViewModel())
    private let stepsChart = StepsChart(viewModel: StepsChartViewModel())
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startObservingStepsChanges()
        setupObservers()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObservingStepsChanges()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupVerticalStackView()
        setupProfileImageView()
        setupStepsAndDate()
        setupStepsChart()
        setupAchievementsCollectionView()
    }
    
    private func setupObservers() {
        viewModel.session.databaseManager.stepsInCurrentMonth.sink { [weak self] stepsInMonth in
            guard let self, let stepsInMonth else {
                return
            }
            let achievements = viewModel.calculateAchievements(from: stepsInMonth.days)
            achievementsCollectionView.viewModel.achievements = achievements
            DispatchQueue.main.async { [weak self] in
                self?.stepsCountLabel.text = stepsInMonth.getFormattedTotalSteps()
                self?.setupAchievementLabel(achievementCount: String(achievements.count))
            }
        }
        .store(in: &subscriptions)
    }
    
    private func setupVerticalStackView() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 7
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupProfileImageView() {
        // Initialize the stack view
        profilePictureZStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(profilePictureZStackView)
        
        // Configure the background image view
        let profilePhotoBackground = UIImageView(image: UIImage(named: "background"))
        profilePhotoBackground.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoBackground.contentMode = .scaleAspectFill
        
        // Configure the profile image view
        let profileImageView = UIImageView(image: UIImage(named: "profile-photo"))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.grey01.cgColor
        profileImageView.layer.cornerRadius = profilePictureSize / 2 // Half the size for a circular image
        profileImageView.clipsToBounds = true
        
        
        // Add both image views to the zStackView
        profilePictureZStackView.addSubview(profilePhotoBackground)
        profilePictureZStackView.addSubview(profileImageView)
        profilePictureZStackView.bringSubviewToFront(profileImageView)
        
        // Setup constraints for zStackView
        NSLayoutConstraint.activate([
            profilePictureZStackView.widthAnchor.constraint(equalToConstant: profilePictureSize),
            profilePictureZStackView.heightAnchor.constraint(equalToConstant: profilePictureSize)
        ])
        
        // Setup constraints for profilePhotoBackground
        NSLayoutConstraint.activate([
            profilePhotoBackground.centerXAnchor.constraint(equalTo: profilePictureZStackView.centerXAnchor),
            profilePhotoBackground.centerYAnchor.constraint(equalTo: profilePictureZStackView.centerYAnchor),
            profilePhotoBackground.widthAnchor.constraint(equalToConstant: backgroundSize),
            profilePhotoBackground.heightAnchor.constraint(equalToConstant: backgroundSize)
        ])
        
        // Setup constraints for profileImageView
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: profilePictureZStackView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profilePictureZStackView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: profilePictureSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profilePictureSize)
        ])
    }
    
    private func setupStepsAndDate() {
        // This stack view contains the Steps title and Date
        let stepsTitleAndDateStackView = UIStackView()
        stepsTitleAndDateStackView.axis = .vertical
        stepsTitleAndDateStackView.spacing = 4

        let stepsCountAndDateStackView = UIStackView()
        stepsCountAndDateStackView.axis = .horizontal
        stepsCountAndDateStackView.alignment = .center

        verticalStackView.addArrangedSubview(stepsCountAndDateStackView)

        // Add the "Steps" title and date labels to the stack view
        stepsTitleAndDateStackView.addArrangedSubview(stepsTitleLabel)
        stepsTitleLabel.text = "Steps"
        stepsTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)

        stepsTitleAndDateStackView.addArrangedSubview(dateLabel)
        dateLabel.text = viewModel.session.utils.getCurrentMonthYear()
        dateLabel.alpha = 0.5
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)

        // Adding title and date stack view and the steps count label to the horizontal stack view
        stepsCountAndDateStackView.addArrangedSubview(stepsTitleAndDateStackView)
        stepsCountAndDateStackView.addArrangedSubview(stepsCountLabel)
        stepsCountLabel.textAlignment = .right
        stepsCountLabel.textColor = .green01
        stepsCountLabel.font = .systemFont(ofSize: 32, weight: .regular)

        // Set constraints for the horizontal stack view
        NSLayoutConstraint.activate([
            stepsCountAndDateStackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: horizontalMargin),
            stepsCountAndDateStackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: -horizontalMargin),
            stepsCountAndDateStackView.centerXAnchor.constraint(equalTo: verticalStackView.centerXAnchor)
        ])
    }


    private func setupStepsChart() {
        
        stepsChart.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(stepsChart)

        NSLayoutConstraint.activate([
            stepsChart.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            stepsChart.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            stepsChart.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    private func setupAchievementsCollectionView() {
        achievementsLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementsLabel.textAlignment = .left
        
        achievementsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let achievementsContainerView = UIView()
        achievementsContainerView.translatesAutoresizingMaskIntoConstraints = false
        achievementsContainerView.clipsToBounds = true // Ensure it doesn't overlap other views
        verticalStackView.addArrangedSubview(achievementsContainerView)

        achievementsContainerView.addSubview(achievementsLabel)
        achievementsContainerView.addSubview(achievementsCollectionView)
        
        // Constraints for the achievements container view
        NSLayoutConstraint.activate([
            achievementsContainerView.topAnchor.constraint(equalTo: stepsChart.bottomAnchor, constant: 44),
            achievementsContainerView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            achievementsContainerView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            achievementsCollectionView.bottomAnchor.constraint(equalTo: achievementsContainerView.bottomAnchor, constant: -81) // Ensure spacing to the bottom
        ])

        // Constraints for achievements title label
        NSLayoutConstraint.activate([
            achievementsLabel.topAnchor.constraint(equalTo: achievementsContainerView.topAnchor),
            achievementsLabel.leadingAnchor.constraint(equalTo: achievementsContainerView.leadingAnchor, constant: horizontalMargin),
            achievementsLabel.trailingAnchor.constraint(equalTo: achievementsContainerView.trailingAnchor, constant: -horizontalMargin)
        ])
        
        // Constraints for the achievements collection view
        NSLayoutConstraint.activate([
            achievementsCollectionView.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 24), // Space between label and collection view
            achievementsCollectionView.leadingAnchor.constraint(equalTo: achievementsContainerView.leadingAnchor),
            achievementsCollectionView.trailingAnchor.constraint(equalTo: achievementsContainerView.trailingAnchor),
            achievementsCollectionView.heightAnchor.constraint(equalToConstant: 176) // Height of the collection view
        ])
    }

    
    private func setupAchievementLabel(achievementCount: String) {
        // Create an attributed string with different colors
        let achievementsText = NSMutableAttributedString(string: "Achievements ", attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label // Use the default label color or your desired color
        ])
        
        let numberText = NSAttributedString(string: achievementCount, attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.blue01
        ])
        
        achievementsText.append(numberText)
        
        achievementsLabel.attributedText = achievementsText
    }
}

