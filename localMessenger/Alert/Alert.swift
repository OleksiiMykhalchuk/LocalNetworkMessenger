//
//  Alert.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/15/22.
//

import Foundation
import UIKit

struct Alerts {
    let error: Error
    private lazy var window: UIWindow = {
        guard let window = UIApplication.shared.windows.first else { return UIWindow() }
        return window
    }()
    public init(error: Error) {
        self.error = error
    }
    mutating func showAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        window.rootViewController?.present(alert, animated: true)
    }
}
