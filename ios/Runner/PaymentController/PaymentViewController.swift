//
//  PaymentViewController.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import UIKit
import FinixPOS

class PaymentViewController: UIViewController, ShowAlert {
    
    var payment: PaymentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        FINIXHELPER.finixHelperDelegate = self
        performPayment()
    }
    
    func performPayment() {
        self.showHUD(message: "Initializing")
        
        if FINIXHELPER.isSDKInitialized() {
            
            self.performSale()
            
        } else {
            
            self.initializeSDK()
        }
    }
    
    func initializeSDK() {
        
        let serialNumber: String? = nil
        
        FINIXHELPER.initializeFinixSDK(environment: FinixPOS.Finix.Environment.TestCertification,
                                       userName: FinixConstants.userName,
                                       password: FinixConstants.password,
                                       application: "Test",
                                       version: "1.0",
                                       merchantId: "MUuGRWnvvg62MxAmMpzGcXxq",
                                       deviceID: "DV9jHr66AG5bc5qorHDRPpMK",
                                       serialNumber: serialNumber)
    }
    
    func performSale() {
        
        FINIXHELPER.performSale(billAmount: 3.14,
                                testTags: ["Test": "Test",
                                           "order_number": "21DFASJSAKAS"])
    }
    
    func showAlert(title: String, message: String) {
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismissView()
        }
        displayAlert(with: title, message: message, type: .alert, actions: [okAction])
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PaymentViewController: FinixHelperDelegate {
    
    func sdkInitialzed(error: Error?) {
        dismissHUD(isAnimated: true)
        print("==========SDK Initialized: \(error.debugDescription)==========")
    }
    
    func sdkDeinitialzed(error: Error?) {
        dismissHUD(isAnimated: true)
        print("==========SDK Deinitialized: \(error.debugDescription)==========")
    }
    
    func deviceDidConnect(_ description: String, model: String, serialNumber: String) {
        
        print("==========Device Did Connect:\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
        
        self.performSale()
    }
    
    func deviceDidDisconnect() {
        
        print("==========Device Did Disconnect==========")
    }
    
    func deviceInitialization(inProgress currentProgress: Double, description: String, model: String, serialNumber: String) {
        
        print("==========Device Initialization:\nProgress:\(currentProgress)\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
    }
    
    func deviceDidError(_ error: Error) {
        dismissHUD(isAnimated: true)
        
        showAlert(title: "Error", message: error.localizedDescription)
        print("==========Device Did Error: \(error.localizedDescription)==========")
    }
    
    func statusDidChange(_ status: FinixPOS.DeviceStatus, description: String) {
        print("==========Device Status change:\(status), description:\(description)==========")
    }
    
    func onBatteryLow() {
        
        print("==========Device Battery Low==========")
    }
    
    func prereadTimedOut() {
        
        print("==========Device Preread Time Out==========")
    }
    
    func onDisplayText(_ text: String) {
        
        print("==========On display text: \(text)==========")
    }
    
    func onRemoveCard() {
        
        print("==========Card removed==========")
    }
    
    func saleResponseFailed(error: Error) {
        
        print("==========Sale Response Failed with error : \(error)==========")
        FINIXHELPER.deinitializeFinixSDK()
        dismissHUD(isAnimated: true)
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func saleResponseSuccess(response: String) {
        
        print("==========Sale Response Success With Receipt: \(response)==========")
        
        FINIXHELPER.deinitializeFinixSDK()
        dismissHUD(isAnimated: true)
        showAlert(title: "Success", message: response)
    }
    
}
