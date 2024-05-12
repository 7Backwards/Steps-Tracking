//
//  StepsChart.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import UIKit
import Combine
import SwiftUI
import Charts
import OSLog

class StepsChart: UIView {
    
    // MARK: - Properties
    
    let viewModel: StepsChartViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var hostingController: UIHostingController<StepsChartView>?

    // MARK: - Init
    
    init(viewModel: StepsChartViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupChart() {
        os_log("Setting up the StepsChart view", type: .info)
        let chartView = StepsChartView()
        hostingController = UIHostingController(rootView: chartView)
        
        guard let hostingView = hostingController?.view else {
            os_log("Failed to load the hosting controller view", type: .error)
            return 
        }
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: self.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Observing changes in the data
        viewModel.shouldReloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                os_log("Received notification to reload data in StepsChart", type: .info)
                self?.updateChartData()
            }
            .store(in: &subscriptions)
    }
    
    private func updateChartData() {
        guard let stepsData = viewModel.stepsInMonth?.days else {
            os_log("No step data available to update the chart", type: .info)
            return
        }
        os_log("Updating chart data with %d entries", type: .info, stepsData.count)
        // Update the SwiftUI chart with the new data
        hostingController?.rootView = StepsChartView(stepsData: stepsData)
        hostingController?.view.setNeedsDisplay() // Refresh the view
    }
}

struct StepsChartView: View {
    
    // MARK: - Properties

    var stepsData: [StepsPerDay]?
    
    // MARK: - Body
    
    var body: some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#0074FF"), Color(hex: "#B4EC51")]),
            startPoint: .bottom, 
            endPoint: .top
        )
        
        if let stepsData {
            Chart {
                // Add a conditional LineMark only if there are steps
                ForEach(stepsData, id: \.date) { stepsPerDay in
                    if stepsPerDay.steps > 0 {
                        LineMark(
                            x: .value("Day", Calendar.current.component(.day, from: stepsPerDay.date)),
                            y: .value("Steps", stepsPerDay.steps)
                        )
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(gradient)
                    }
                }
                
                // Workaround for the no steps state to look like the design
                RectangleMark(
                    xStart: .value("Day", [1, 5, 10, 15, 20, 25, 30].first!),
                    xEnd: .value("Day", [1, 5, 10, 15, 20, 25, 30].last!),
                    yStart: .value("Steps", [0, 10, 20, 30].first!),
                    yEnd: .value("Steps", [0, 10, 20, 30].last!)
                )
                .opacity(0)
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom, values: [1, 5, 10, 15, 20, 25, 30]) { _ in
                    AxisValueLabel()
                }
            }
            .chartXScale(domain: 0...35)
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .trailing) { value in
                    // Hide last y grid line as per design
                    if value.index < 3 {
                        AxisGridLine()
                    }
                    AxisValueLabel()
                }
            }
        }
    }
}
