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
        
        getFont(controller)
        
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
                let cvv = args["cvv"] as? Int ?? 0
                let zipcode = args["zipcode"] as? String ?? ""
                
                self.getFinixPaymentToken(cardNumber: cardNumber, expMonth: expMonth, expYear: expYear, cvv: cvv, zipcode: zipcode) { token in
                    self.cardPaymentChannel.invokeMethod("getPaymentToken", arguments: [token])
                }
            case "showTipScreen":
                self.loadTipView(nil)
           
            case "captureTipAmount":
                guard let args = call.arguments as? [String: Any] else { return }
                let tipAmount = args["tipAmount"] as? Double ?? 0
                NotificationCenter.default.post(name: Notification.Name("CapturePayment"),
                                                object: nil,
                                                userInfo: ["tip": tipAmount])
                
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
        
        let navigationController = UINavigationController(rootViewController: paymentViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        
        window.rootViewController?.present(navigationController, animated: true)
    }
    
    func loadTipView(_ amount: Double?) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let tipViewController = storyBoard.instantiateViewController(withIdentifier: "TipViewController") as? TipViewController else { return }
        
        if(amount != nil) {
            tipViewController.billAmount = amount
        }
        tipViewController.view.backgroundColor = UIColor.clear
        tipViewController.modalPresentationStyle = .overFullScreen
        
        tipViewController.selectedTipAmount = { [weak self] (tipAmount) in
            print(tipAmount)
            self?.cardPaymentChannel.invokeMethod("getTipAmount", arguments: [tipAmount])
        }
        
        window.rootViewController?.present(tipViewController, animated: true)
    }
    
    fileprivate func getFont(_ controller: FlutterViewController) {
        let bundle = Bundle.main
        let fontKey = controller.lookupKey(forAsset: "assets/fonts/Montserrat-Bold.ttf")
        let path = bundle.path(forResource: fontKey, ofType: nil)
        guard let fontData = NSData(contentsOfFile: path ?? "") else { return }
        guard let dataProvider = CGDataProvider(data: fontData) else { return }
        guard let fontRef = CGFont(dataProvider) else { return }
        var errorRef: Unmanaged<CFError>? = nil
        CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
    }
}

extension AppDelegate {
    
    static var delegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
    
    func getFinixPaymentToken(cardNumber: String, expMonth: Int, expYear: Int, cvv: Int, zipcode: String, onCompletion: @escaping (String) -> Void) {
        
        let tokenizer = Tokenizer(host: FinixConstants.hostUrl, applicationId: FinixConstants.applicationId)
        var address = Address()
        address.postal_code = zipcode
        
        tokenizer.createToken(cardNumber: cardNumber,
                              paymentType: PaymentType.PAYMENT_CARD,
                              expirationMonth: expMonth,
                              expirationYear: expYear,
                              securityCode: String(cvv),
                              address: address) { (token, error) in
            guard let token = token else {
                print(error!.localizedDescription)
                onCompletion("")
                return
            }
            onCompletion(token.id)
        }
    }
}
