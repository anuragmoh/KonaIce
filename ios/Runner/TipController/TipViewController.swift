//
//  TipViewController.swift
//  Runner
//
//  Created by Prashant Telangi on 23/06/22.
//

import UIKit

class TipViewController: UIViewController {
    
    @IBOutlet weak var addTipLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var customAmountTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tipAmountOneButton: UIButton!
    @IBOutlet weak var tipAmountTwoButton: UIButton!
    @IBOutlet weak var tipAmountThreeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var noTipButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var billAmount: Double? = 0
    
    enum TipAmount: Int {
        case oneDollar = 1
        case twoDollar = 2
        case threeDollar = 3
        case otherAmount = 4
        case noTip = 5
    }
    
    var selectedTipAmount: ((Double) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerObservers()
        addVisualEffectBlurrView()
        setupView()
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.customerPaymentNotification(_:)),
                                               name: Notification.Name("CapturePayment"),
                                               object: nil)
    }
    
    @objc func customerPaymentNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            if let customerTipAmount = userInfo["tipAmount"] as? Double {
                
                self.customAmountTextField.text = String(customerTipAmount)
                self.confirmButtonTapped()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= getMoveableDistance(keyboarHeight: keyboardSize.height)
            }
        }
    }
    
    func getMoveableDistance(keyboarHeight : CGFloat) ->  CGFloat{
        
        var y:CGFloat = 0.0
        if let active = customAmountTextField {
            var tfMaxY = active.frame.maxY
            var containerView = active.superview!
            while containerView.frame.maxY != self.view.frame.maxY{
                let contViewFrm = containerView.convert(active.frame, to: containerView.superview)
                tfMaxY = tfMaxY + contViewFrm.minY
                containerView = containerView.superview!
            }
            let keyboardMinY = self.view.frame.height - keyboarHeight
            if tfMaxY > keyboardMinY{
                y = (tfMaxY - keyboardMinY) + 10.0
            }
        }
        
        return y
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func addVisualEffectBlurrView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    fileprivate func setupTextField() {
        customAmountTextField.font = UIFont(name: "Montserrat-Bold", size: 16)
        customAmountTextField.textColor = UIColor.textColor
        customAmountTextField.leftViewMode = .always
        customAmountTextField.keyboardType = .numberPad
        
        let dollarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        dollarLabel.text = "$"
        dollarLabel.layer.borderColor = UIColor.textColor.cgColor
        dollarLabel.textColor = UIColor.textColor
        dollarLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dollarLabel.textAlignment = .center
        let dollarIcon = UIImage.imageWithLabel(label: dollarLabel)
        
        customAmountTextField.leftView = UIImageView(image: dollarIcon)
        customAmountTextField.delegate = self
        customAmountTextField.addTarget(self, action:  #selector(amountDidChange), for: .editingChanged)
    }
    
    func setupView() {
        
        self.navigationItem.hidesBackButton = true
        
        setupTextField()
        
        addTipLabel.textColor = UIColor.textColor
        addTipLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        
        amountLabel.textColor = UIColor.textColor
        amountLabel.text = "$\(billAmount ?? 0)"
        amountLabel.font = UIFont(name: "Montserrat-Bold", size: 30)
        
        tipAmountOneButton.backgroundColor = UIColor.buttonColor
        tipAmountTwoButton.backgroundColor = UIColor.buttonColor
        tipAmountThreeButton.backgroundColor = UIColor.buttonColor
        otherButton.backgroundColor = UIColor.buttonColor
        confirmButton.backgroundColor = UIColor.buttonColor
        noTipButton.backgroundColor = UIColor.buttonColor
        
        tipAmountOneButton.setTitleColor(UIColor.textColor, for: .normal)
        tipAmountOneButton.tag = 1
        tipAmountOneButton.addTarget(self, action: #selector(tipAmountButtonTapped), for: .touchUpInside)
        tipAmountOneButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        tipAmountTwoButton.setTitleColor(UIColor.textColor, for: .normal)
        tipAmountTwoButton.tag = 2
        tipAmountTwoButton.addTarget(self, action: #selector(tipAmountButtonTapped), for: .touchUpInside)
        tipAmountTwoButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        tipAmountThreeButton.setTitleColor(UIColor.textColor, for: .normal)
        tipAmountThreeButton.tag = 3
        tipAmountThreeButton.addTarget(self, action: #selector(tipAmountButtonTapped), for: .touchUpInside)
        tipAmountThreeButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        otherButton.setTitleColor(UIColor.textColor, for: .normal)
        otherButton.tag = 4
        otherButton.addTarget(self, action: #selector(tipAmountButtonTapped), for: .touchUpInside)
        otherButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        confirmButton.setTitleColor(UIColor.textColor, for: .normal)
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
        confirmButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        noTipButton.setTitleColor(UIColor.textColor, for: .normal)
        noTipButton.tag = 5
        noTipButton.addTarget(self, action: #selector(tipAmountButtonTapped), for: .touchUpInside)
        noTipButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        containerView.layer.cornerRadius = 10
        
        tipAmountOneButton.layer.cornerRadius = 25
        tipAmountTwoButton.layer.cornerRadius = 25
        tipAmountThreeButton.layer.cornerRadius = 25
        confirmButton.layer.cornerRadius = 25
        noTipButton.layer.cornerRadius = 25
        otherButton.layer.cornerRadius = 25
    }
    
    @objc func tipAmountButtonTapped(btn: UIButton) {
        switch TipAmount(rawValue: btn.tag) {
        case .oneDollar:
            customAmountTextField.text = "1"
            amountDidChange(textField: customAmountTextField)
        case .twoDollar:
            customAmountTextField.text = "2"
            amountDidChange(textField: customAmountTextField)
        case .threeDollar:
            customAmountTextField.text = "3"
            amountDidChange(textField: customAmountTextField)
        case .otherAmount:
            customAmountTextField.text = ""
            customAmountTextField.becomeFirstResponder()
            amountDidChange(textField: customAmountTextField)
        case .noTip:
            customAmountTextField.text = "0"
            amountDidChange(textField: customAmountTextField)
        default:
            break
        }
    }
    
    @objc func confirmButtonTapped() {
        selectedTipAmount?(Double(customAmountTextField.text ?? "0") ?? 0)
        dismissView()
    }
    
    @objc func amountDidChange(textField: UITextField) {
        if !(textField.text?.isEmpty ?? false) {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
        } else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
        }
    }
    
    func dismissView() {
        if(self.navigationController?.viewControllers.count ?? 0 > 0) {
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
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

extension TipViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let value = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !value.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        let result = numberFormatter.number(from: value)?.intValue != nil
        if result {
            amountDidChange(textField: textField)
        }
        return result
    }
}
