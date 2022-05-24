import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var cardPaymentChannel: FlutterMethodChannel!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let methodChannelName = "com.mobisoft.konaicepos/cardPayment"
        
        cardPaymentChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)
        
        cardPaymentChannel.setMethodCallHandler ({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "performCardPayment":
                guard let args = call.arguments as? [String: Any] else { return }
                let username = args["username"] as? String ?? ""
                let password = args["password"] as? String ?? ""
                let application = args["application"] as? String ?? ""
                let version = args["version"] as? String ?? ""
                let merchantId = args["merchantId"] as? String ?? ""
                let deviceID = args["deviceID"] as? String ?? ""
                let serialNumber = args["serialNumber"] as? String ?? ""
                let amount = args["amount"] as? Double ?? 0.0
                let tags = args["tags"] as? [String: String] ?? [:]
                
                let paymentModel =  PaymentModel(username: username,
                                                 password: password,
                                                 application: application,
                                                 version: version,
                                                 deviceID: deviceID,
                                                 merchantID: merchantId,
                                                 serialNumber: serialNumber,
                                                 amount: amount,
                                                 tags:tags )
                self.loadPaymentView(paymentModel)
                result("")
            default: result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func loadPaymentView(_ payment: PaymentModel) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else { return }
        paymentViewController.payment = payment
        paymentViewController.view.backgroundColor = UIColor.clear
        paymentViewController.modalPresentationStyle = .overCurrentContext
        window.rootViewController?.present(paymentViewController, animated: true)
    }
}

extension AppDelegate {
    
    static var delegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
}
