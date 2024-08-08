//
//  AlertHelper.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/7/24.
//

import UIKit


class AlertHelper {
    static func createAlertController(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        return alertController
    }
}
