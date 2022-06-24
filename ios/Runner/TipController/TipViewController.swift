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
    @IBOutlet weak var noTipButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        addTipLabel.textColor = UIColor.textColor
        amountLabel.textColor = UIColor.textColor
        
        customAmountTextField.textColor = UIColor.textColor
        
        tipAmountOneButton.backgroundColor = UIColor.buttonColor
        tipAmountTwoButton.backgroundColor = UIColor.buttonColor
        tipAmountThreeButton.backgroundColor = UIColor.buttonColor
        confirmButton.backgroundColor = UIColor.buttonColor
        noTipButton.backgroundColor = UIColor.buttonColor
        
        containerView.layer.cornerRadius = 10
        
        tipAmountOneButton.layer.cornerRadius = 10
        tipAmountTwoButton.layer.cornerRadius = 10
        tipAmountThreeButton.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 10
        noTipButton.layer.cornerRadius = 10
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
