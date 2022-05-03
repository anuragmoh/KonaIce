//
//  PaymentViewController.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import UIKit
import FinixPOS

class PaymentViewController: UIViewController, ShowAlert {
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var payment: PaymentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        FINIXHELPER.finixHelperDelegate = self
        performPayment()
    }
    
    func setupView() {
        progressView.layer.cornerRadius = 10
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    func performPayment() {
        activityIndicator.startAnimating()
        updateStatus(msg: "Initializing")
        
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
                                       application: payment.application,
                                       version: payment.version,
                                       merchantId: payment.merchantID,
                                       deviceID: payment.deviceID,
                                       serialNumber: serialNumber)
    }
    
    func performSale() {
        
        FINIXHELPER.performSale(billAmount: Decimal(payment.amount),
                                testTags: payment.tags)
    }
    
    func showAlert(title: String, message: String, paymentSuccess: Bool, response: String? = "") {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                if(paymentSuccess) {
                    AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentSuccess", arguments: [response])
                } else {
                    AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentFailed", arguments: [""])
                }
                self.dismissView()
            }
            self.displayAlert(with: title, message: message, type: .alert, actions: [okAction])
        }
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    func updateStatus(msg: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = msg
        }
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
        if (error != nil){
            showAlert(title: "Error", message: error!.localizedDescription, paymentSuccess: false)
        }
        print("==========SDK Initialized: \(error.debugDescription)==========")
    }
    
    func sdkDeinitialzed(error: Error?) {
        if (error != nil){
            showAlert(title: "Error", message: error!.localizedDescription, paymentSuccess: false)
        }
        print("==========SDK Deinitialized: \(error.debugDescription)==========")
    }
    
    func deviceDidConnect(_ description: String, model: String, serialNumber: String) {
        updateStatus(msg: "Device Connected")
        
        print("==========Device Did Connect:\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
        
        self.performSale()
        
        updateStatus(msg: "Performing Transaction")
    }
    
    func deviceDidDisconnect() {
        print("==========Device Did Disconnect==========")
    }
    
    func deviceInitialization(inProgress currentProgress: Double, description: String, model: String, serialNumber: String) {
        print("==========Device Initialization:\nProgress:\(currentProgress)\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
    }
    
    func deviceDidError(_ error: Error) {
        showAlert(title: "Error", message: error.localizedDescription, paymentSuccess: false)
        print("==========Device Did Error: \(error.localizedDescription)==========")
    }
    
    func statusDidChange(_ status: FinixPOS.DeviceStatus, description: String) {
        updateStatus(msg: description)
        print("==========Device Status change:\(status), description:\(description)==========")
    }
    
    func onBatteryLow() {
        print("==========Device Battery Low==========")
    }
    
    func prereadTimedOut() {
        print("==========Device Preread Time Out==========")
    }
    
    func onDisplayText(_ text: String) {
        updateStatus(msg: text)
        print("==========On display text: \(text)==========")
    }
    
    func onRemoveCard() {
        print("==========Card removed==========")
    }
    
    func saleResponseFailed(error: Error) {
        
        print("==========Sale Response Failed with error : \(error)==========")
        showAlert(title: "Error", message: error.localizedDescription, paymentSuccess: false)
    }
    
    func saleResponseSuccess(saleResponseReceipt: SaleResponseReceipt?) {
        
        print("==========Sale Response Success With Receipt: \(String(describing: saleResponseReceipt))==========")
        showAlert(title: "Success", message: saleResponseReceipt.debugDescription, paymentSuccess: true, response: saleResponseReceipt.debugDescription)
    }
    
}
