import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let methodChannelName = "com.mobisoft.konaicepos/cardPayment"
        
        let cardPaymentChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)
        
        cardPaymentChannel.setMethodCallHandler ({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "performCardPayment":
                guard let args = call.arguments as? [String: Any] else { return }
                let application = args["application"] as? String ?? ""
                let version = args["version"] as? String ?? ""
                let merchantId = args["merchantId"] as? String ?? ""
                let deviceID = args["deviceID"] as? String ?? ""
                let amount = args["amount"] as? Double ?? 0.0
                
                let paymentModel =  PaymentModel(application: application,
                                                 version: version,
                                                 deviceID: deviceID,
                                                 merchantID: merchantId,
                                                 serialNumber: nil,
                                                 amount: amount)
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
