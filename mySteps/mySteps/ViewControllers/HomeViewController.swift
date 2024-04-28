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

    let viewModel: HomeViewModel
    private var subscriptions: [AnyCancellable] = []
    let tableView: AchievementsTableView = AchievementsTableView(viewModel: AchievementsTableViewModel(), frame: .zero)
    let stepsChart = StepsChart(viewModel: StepsChartViewModel())

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
        self.view.backgroundColor = .red
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
        view.addSubview(tableView)
    }
    
    private func setupObservers() {
        viewModel.session.databaseManager.stepsInCurrentMonth.sink { [weak self] stepsInMonth in
            guard let self, let stepsInMonth else {
                return
            }

            tableView.viewModel.achievements = viewModel.calculateAchievements(from: stepsInMonth.days)
        }
        .store(in: &subscriptions)
    }
}

