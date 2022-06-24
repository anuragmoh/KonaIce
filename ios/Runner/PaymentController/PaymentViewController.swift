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
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var payment: PaymentModel!
    
    var transactionAnimationView: AnimationView!
    
    var authorizationResponseString: String?
    
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
        
        self.statusLabel.textColor = .white
        self.enableLogging(false)
        
        self.cancelButton.addTarget(self, action: #selector(cancelTransactionButtonTapped), for: .touchUpInside)
    }
    
    func enableLogging(_ enable: Bool) {
        
        self.statusLabel.isHidden = !enable
    }
    
    func performPayment() {
        
        if FINIXHELPER.isSDKInitialized() {
            
            self.performSale()
            
        } else {
            
            self.initializeSDK()
        }
    }
    
    func checkIfCreditCardCanScan() -> Bool {
        
        if FINIXHELPER.isSDKInitialized() {
            
            if FINIXHELPER.isReaderConnected() {
                
                print("==========SDK initialzed & reader connected, show scan option==========")
                
                return true
                
            } else {
                
                print("==========SDK initialzed but reader not connected, disable scan option==========")
                
                return false
            }
            
        } else {
            
            print("==========SDK not initialzed, show scan option==========")

            return true
        }
    }
    
    @objc func cancelTransactionButtonTapped() {
        
        if FINIXHELPER.cancelSale() {
            
            print("==========Sale Cancelled==========")
            
            DispatchQueue.main.async {
                
                self.statusLabel.text = "==========Sale Cancelled=========="
            }
            
            AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentFailed", arguments: [""])
            
            self.dismissView()
            
        } else {
            
            print("==========Sale Cancellation Failed==========")
            
            DispatchQueue.main.async {
                
                self.statusLabel.text = "==========Sale Cancellation Failed=========="
            }
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
        
        FINIXHELPER.performaAuthorization(billAmount: Decimal(payment.amount),
                                          testTags: payment.tags)
        
        //performSale(billAmount: Decimal(payment.amount), testTags: payment.tags)
    }
    
    func showAlert(title: String, message: String, transactionModelString: String? = nil) {
        
        DispatchQueue.main.async {
            
            self.stopAnimationView()
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                
                if let transactionModelString = transactionModelString {
                    
                    AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentSuccess", arguments: transactionModelString)
                    
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
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = error.debugDescription
        }
    }
    
    func sdkDeinitialzed(error: Error?) {
        
        if (error != nil) {
            
            showAlert(title: "Error", message: error!.localizedDescription)
        }
        
        print("==========SDK Deinitialized: \(error.debugDescription)==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = error.debugDescription
        }
    }
    
    func deviceDidConnect(_ description: String, model: String, serialNumber: String) {
        
        print("==========Device Did Connect:\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "Device Did Connect:\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)"
        }
        
        self.performSale()
    }
    
    func deviceDidDisconnect() {
        
        showAlert(title: "Error", message: "Device Disconnected")
        
        print("==========Device Did Disconnect==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "Device Did Disconnect"
        }
        
        FINIXHELPER.deinitializeFinixSDK()
    }
    
    func deviceInitialization(inProgress currentProgress: Double, description: String, model: String, serialNumber: String) {
        
        print("==========Device Initialization:\nProgress:\(currentProgress)\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "==========Device Initialization:\nProgress:\(currentProgress)\nDescription:\(description)\nmodel:\(model)\nserial:\(serialNumber)=========="
        }
    }
    
    func deviceDidError(_ error: Error) {
        
        showAlert(title: "Error", message: error.localizedDescription)
        
        print("==========Device Did Error: \(error.localizedDescription)==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "==========Device Did Error: \(error.localizedDescription)=========="
        }
        
        FINIXHELPER.deinitializeFinixSDK()
    }
    
    func statusDidChange(_ status: FinixPOS.DeviceStatus, description: String) {
        
        print("==========Device Status change:\(status), description:\(description)==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Device Status change:\(status), description:\(description)=========="
        }
    }
    
    func onBatteryLow() {
        
        print("==========Device Battery Low==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Device Battery Low=========="
        }
    }
    
    func prereadTimedOut() {
        
        print("==========Device Preread Time Out==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Device Preread Time Out=========="
        }
    }
    
    func onDisplayText(_ text: String) {
        
        print("==========On display text: \(text)==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========On display text: \(text)=========="
        }
        
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
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Card removed=========="
        }
        
        showTransactionAnimationView(with: .removeCard)
    }
    
    func authorizationResponseFailed(error: Error) {
        
        print("==========Authorization Response Failed with error : \(error)==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Authorization Response Failed with error : \(error)=========="
        }
        
        showAlert(title: "Error", message: "\(error)")
    }
    
    func authorizationResponseSuccess(authorizationResponseModel: AuthorizationResponseModel?) {
        
        print("==========Authorization Response Success With Receipt: \(String(describing: authorizationResponseModel))==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Authorization Response Success With Receipt: \(String(describing: authorizationResponseModel))=========="
        }
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(authorizationResponseModel) {
            
            if let content = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                print("==========Authorization Response Json String: \(content)")
                
                DispatchQueue.main.async {
                    
                    self.statusLabel.text = "==========Authorization Response Json String: \(content)"
                }
                
                self.authorizationResponseString = content
                
                FINIXHELPER.performCapture(authorizationId: authorizationResponseModel?.finixAuthorizationResponse.transferId ?? "",
                                           billAmount: Decimal(payment.amount))
            }
        }
    }
    
    func captureResponseFailed(error: Error?) {
        
        print("==========Capture Response Failed with error : \(String(describing: error))==========")
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "==========Capture Response Failed with error : \(String(describing: error))=========="
        }
        
        showAlert(title: "Error", message: "\(String(describing: error))")
    }
    
    func captureResponseSuccess(transactionResponseModel: TransactionResponseModel?) {
        
        print("==========Capture Response Success: \(String(describing: transactionResponseModel))==========")
        
        DispatchQueue.main.async {
            self.statusLabel.text = "==========Capture Response Success: \(String(describing: transactionResponseModel))=========="
        }
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(transactionResponseModel) {
            
            if let content = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                print("==========Capture Response Json String: \(content)")
                
                DispatchQueue.main.async {
                    
                    self.statusLabel.text = "==========Capture Response Json String: \(content)"
                }
                
                // showAlert(title: "Payment Success", message: content, transactionModelString: content)
                
                AppDelegate.delegate?.cardPaymentChannel.invokeMethod("paymentSuccess", arguments: content)
                
                self.dismissView()
            }
        }
    }
}
