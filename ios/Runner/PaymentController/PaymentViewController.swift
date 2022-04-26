//
//  PaymentViewController.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import UIKit
import FinixPOS

class PaymentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        FINIXHELPER.finixHelperDelegate = self
        performPayment()
    }
    
    func performPayment() {
        if FINIXHELPER.isSDKInitialized() {
            
            self.performSale()
            
        } else {
            
            self.initializeSDK()
        }
    }
    
    func initializeSDK() {
        
        let serialNumber: String? = nil
        
        FINIXHELPER.initializeFinixSDK(environment: FinixPOS.Finix.Environment.TestCertification,
                                       userName: "US5XSPK8w4W8dCHT9t7fUUYz",
                                       password: "9cb05bbf-b768-4bb5-a680-48fee02e570c",
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
        
        print("==========SDK Initialized: \(error.debugDescription)==========")
    }
    
    func sdkDeinitialzed(error: Error?) {
        
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
    }
    
    func saleResponseSuccess(response: String) {
        
        print("==========Sale Response Success With Receipt: \(response)==========")
        
        FINIXHELPER.deinitializeFinixSDK()
    }
}
