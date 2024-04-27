//
//  StepsChart.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit
import DGCharts

class StepsChart: LineChartView {
    let viewModel: StepsChartViewModel
    
    init(viewModel: StepsChartViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
