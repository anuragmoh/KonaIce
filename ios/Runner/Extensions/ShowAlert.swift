//
//  ShowAlert.swift
//  MIExtensions
//
//  Created by Prashant Telangi on 6/25/20.
//

import UIKit

public protocol ShowAlert {
    func displayAlert(with title: String, message: String, type: UIAlertController.Style?, actions: [UIAlertAction]?)
}

public extension ShowAlert where Self: UIViewController {
    
    func displayAlert(with title: String, message: String, type: UIAlertController.Style? = .alert, actions: [UIAlertAction]? = nil) {
        
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }
        }
        
        let alertController  = UIAlertController(title: title, message: message, preferredStyle: type ?? .alert)
        actions?.forEach({ action in
            alertController.addAction(action)
        })
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
