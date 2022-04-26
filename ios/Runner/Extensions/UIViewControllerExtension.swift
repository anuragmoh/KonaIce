//
//  UIViewControllerExtension.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showHUD(message: String ){
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = message
        }
    }
    
    func dismissHUD(isAnimated: Bool) {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }
    }
}
