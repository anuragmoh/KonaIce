//
//  PaymentViewController.swift
//  Runner
//
//  Created by Prashant Telangi on 26/04/22.
//

import UIKit
import FinixPOS
import Lottie

class PaymentViewController: UIViewController, ShowAlert {
    
    @IBOutlet weak var containerView: UIView!
    
    var payment: PaymentModel!
    
    var transactionAnimationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        FINIXHELPER.finixHelperDelegate = self
        performPayment()
    }
    
    func setupView() {
        
        addVisualEffectBlurrView()
        
        showTransactionAnimationView(with: .progress)
    }
    
    func performPayment() {
        
        if FINIXHELPER.isSDKInitialized() {
            
            self.performSale()
            
        } else {
            
            self.initializeSDK()
        }
    }
    
    func initializeSDK() {
                
        print("==========Payment Model: \(payment.debugDescription)==========")
        
        var deviceSerialNumber: String? = nil
        
        if let serialNumber = payment.serialNumber, !serialNumber.isEmpty, serialNumber != "null" {
            
            deviceSerialNumber = serialNumber
        }
        
        FINIXHELPER.initializeFinixSDK(environment: FinixPOS.Finix.Environment.TestCertification,
                                       userName: payment.username,
                                       password: payment.password,
                                       application: payment.application,
                                       version: payment.version,
                                       merchantId: payment.merchantID,
                                       deviceID: payment.deviceID,
                                       serialNumber: deviceSerialNumber)
    }
    
    func performSale() {
        
        FINIXHELPER.performSale(billAmount: Decimal(payment.amount),
                                testTags: payment.tags)
    }
    
    func showAlert(title: String, message: String, transactionModelString: String? = nil) {
        
        DispatchQueue.main.async {
            
            self.stopAnimationView()
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                
                if let transactionModelString = transactionModelString {
                    
                    AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentSuccess", arguments: [transactionModelString])
                    
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
    
    func addVisualEffectBlurrView() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    func stopAnimationView() {
        
        if let transactionAnimation = self.transactionAnimationView {
            
            transactionAnimation.stop()
            transactionAnimation.removeFromSuperview()
        }
    }
    
    func showTransactionAnimationView(with animationName: TransactionAnimationName, displayText: String = "") {
        
        DispatchQueue.main.async {
            
            AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentStatus", arguments: [animationName.rawValue])

            self.stopAnimationView()
            
            self.transactionAnimationView = AnimationView(name: animationName.rawValue)
            self.transactionAnimationView.contentMode = .scaleAspectFit
            self.transactionAnimationView.backgroundColor = .clear
            self.transactionAnimationView.animationSpeed = 1
            
            var lottieLoopMode: LottieLoopMode = .loop
            
            if animationName == .removeCard &&
                displayText == FinixDisplayText.thankYou.rawValue {
                
                lottieLoopMode = .playOnce
            }
            
            self.transactionAnimationView.play(fromProgress: AnimationProgressTime(0.0),
                                               toProgress: AnimationProgressTime(1.0),
                                               loopMode: lottieLoopMode) { finished in
                
                if finished &&
                    animationName == .removeCard &&
                    displayText == FinixDisplayText.thankYou.rawValue {
                    
                    self.showTransactionAnimationView(with: .progress)
                }
            }
            
            self.containerView.addSubview(self.transactionAnimationView)
            self.view.backgroundColor = .clear
            self.containerView.backgroundColor = .clear
            
            self.transactionAnimationView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.transactionAnimationView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
                self.transactionAnimationView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
                self.transactionAnimationView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
                self.transactionAnimationView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor)
            ])
        }
    }
}

extension PaymentViewController: FinixHelperDelegate {
    
    func sdkInitialzed(error: Error?) {
        
        if (error != nil) {
            
            showAlert(title: "Error", message: error!.localizedDescription)
        }
        
        print("==========SDK Initialized: \(error.debugDescription)==========")
    }
    
    func sdkDeinitialzed(error: Error?) {
        
        if (error != nil) {
            
            showAlert(title: "Error", message: error!.localizedDescription)
        }
        
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
        
        switch FinixDisplayText(rawValue: text) {
            
        case .insertTapSwipeCard:
            showTransactionAnimationView(with: .insertSwipeTapCard)
            
        case .removeCard, .processing, .thankYou:
            showTransactionAnimationView(with: .removeCard, displayText: text)
            
        default:
            showTransactionAnimationView(with: .progress)
        }
    }
    
    func onRemoveCard() {
        
        print("==========Card removed==========")
        
        showTransactionAnimationView(with: .removeCard)
    }
    
    func saleResponseFailed(error: Error) {
        
        print("==========Sale Response Failed with error : \(error)==========")
        
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func saleResponseSuccess(saleResponseReceipt: TransactionResponseModel?) {
        
        print("==========Sale Response Success With Receipt: \(String(describing: saleResponseReceipt))==========")
        
        showAlert(title: "Payment Success", message: saleResponseReceipt.debugDescription, transactionModelString: saleResponseReceipt.debugDescription)
    }
}
