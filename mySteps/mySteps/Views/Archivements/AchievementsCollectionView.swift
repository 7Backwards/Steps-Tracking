//
//  AchievementsCollectionView.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit
import Combine
import OSLog

class AchievementsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties

    private var subscriptions: [AnyCancellable] = []
    let viewModel: AchievementsCollectionViewModel
    var didTapCell: ((Achievement) -> Void)?
    
    // MARK: - Views
    
    private let noContentView = NoContentView(frame: .zero, image: UIImage(named: "no-steps")?.withTintColor(.grey02), title: NSLocalizedString("no_achievements_yet", comment: ""), message: NSLocalizedString("take_first_step", comment: ""))
    
    // MARK: - Init
    
    init(viewModel: AchievementsCollectionViewModel, frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        self.viewModel = viewModel

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: viewModel.cellWidthSize, height: viewModel.cellHeightSize)
        layout.minimumLineSpacing = 24
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.isScrollEnabled = true
        self.delegate = self
        self.dataSource = self
        setupCollectionView()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Adding contentInset so that we match the design default scroll state
        setContentInset()
        noContentView.frame = bounds // Ensure the no content view resizes correctly on layout changes
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        showsHorizontalScrollIndicator = false
        setContentInset()
        register(AchievementsCell.self, forCellWithReuseIdentifier: "AchievementsCell")
    }
    
    private func setContentInset() {
        contentInset = UIEdgeInsets(top: 0, left: 33, bottom: 0, right: 0)
    }
    
    private func setupObservers() {
        viewModel.shouldReloadData.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.reloadData()
            self?.updateNoContentView()
            os_log("AchievementsCollectionView reloaded data", type: .info)
        }
        .store(in: &subscriptions)
    }
    
    private func updateNoContentView() {
        noContentView.isHidden = !viewModel.achievements.isEmpty
        if viewModel.achievements.isEmpty {
            addSubview(noContentView)
            noContentView.frame = bounds
            os_log("No content view displayed", type: .info)
        } else {
            noContentView.removeFromSuperview()
            os_log("No content view removed", type: .info)
        }
    }
    
    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementsCell", for: indexPath) as? AchievementsCell else {
            os_log("Error retrieving AchievementsCell", type: .error)
            return UICollectionViewCell()
        }
        
        let achievement = viewModel.achievements[indexPath.row]
        let cellViewModel = AchievementsViewModel(achievement: achievement)
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        os_log("Achievement selected: %@", type: .info, String(describing: viewModel.achievements[indexPath.row]))
        didTapCell?(viewModel.achievements[indexPath.row])
    }
}
