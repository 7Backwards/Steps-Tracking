//
//  HomeViewController.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties methods

    let viewModel: HomeViewModel
    lazy var tableView = ArchivementsTableView(frame: .zero)

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
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods

}

