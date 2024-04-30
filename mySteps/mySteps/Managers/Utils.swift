//
//  Utils.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import UIKit
import Foundation

class Utils {
    func getCurrentMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonthYear = dateFormatter.string(from: Date())
        return currentMonthYear
    }
    
    func getShowHealthKitPermissionsAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Health Data Required",
            message: "This app requires access to your health data to function properly. Please enable health data access in Settings > Health > Data Access & Devices.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            // Redirect to the app's settings page
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
