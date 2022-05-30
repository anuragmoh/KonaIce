import UIKit
import Flutter
import PaymentsSDK

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
            case "getPaymentToken":
                guard let args = call.arguments as? [String: Any] else { return }
                let cardNumber = args["cardNumber"] as? String ?? ""
                let expMonth = args["expirationMonth"] as? Int ?? 0
                let expYear = args["expirationYear"] as? Int ?? 0
                self.getFinixPaymentToken(cardNumber: cardNumber, expMonth: expMonth, expYear: expYear) { token in
                    self.cardPaymentChannel.invokeMethod("getPaymentToken", arguments: [token])
                }
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
    
    func getFinixPaymentToken(cardNumber: String, expMonth: Int, expYear: Int, onCompletion: @escaping (String) -> Void) {
        
        let tokenizer = Tokenizer(host: "https://api-staging.finix.io",
                                  applicationId: "AP2kL9QSWYJGpuAtYYnK5cZY")
        
        tokenizer.createToken(cardNumber: cardNumber, paymentType: PaymentType.PAYMENT_CARD, expirationMonth: expMonth, expirationYear: expYear) { (token, error) in
            guard let token = token else {
                print(error!.localizedDescription)
                onCompletion("")
                return
            }
            onCompletion(token.id)
        }
        
    }
}
