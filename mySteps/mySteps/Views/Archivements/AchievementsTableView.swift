//
//  AchievementsTableView.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit
import Combine
import OSLog

class AchievementsTableView: UITableView {

    let viewModel: AchievementsTableViewModel
    private var subscriptions: [AnyCancellable] = []
    
    init(viewModel: AchievementsTableViewModel, frame: CGRect = .zero, style: UITableView.Style = .plain) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        
        setupTableView()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        register(AchievementsCell.self, forCellReuseIdentifier: "AchievementsCell")
    }
    
    private func setupObservers() {
        viewModel.shouldReloadData.sink { [weak self] in
            self?.reloadData()
        }
        .store(in: &subscriptions)
    }
}

extension AchievementsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell of type AchievementsCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsCell", for: indexPath) as? AchievementsCell else {
            os_log("Error retrieving AchievementsCell")
            return UITableViewCell()
        }

        // Get the specific StepAchievement for the current indexPath
        let stepAchievement = viewModel.achievements[indexPath.row]
        
        // Create a ViewModel for the cell
        let viewModel = AchievementsCellViewModel(date: stepAchievement.date, steps: stepAchievement.steps, image: stepAchievement.image)

        // Configure the cell's view model
        cell.configure(with: viewModel)
        
        return cell
    }
}
