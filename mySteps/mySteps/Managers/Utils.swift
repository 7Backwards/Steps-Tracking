//
//  Utils.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import UIKit
import Foundation

class Utils {
    
    // MARK: - Public Methods
    
    func getCurrentMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonthYear = dateFormatter.string(from: Date())
        return currentMonthYear
    }
    
    func getShowHealthKitPermissionsAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("healthkit_permission_title", comment: ""),
            message: NSLocalizedString("healthkit_permission_message", comment: ""),
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { _ in
            // Redirect to the app's settings page
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
