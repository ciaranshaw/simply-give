//
//  PaymentViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 19/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    var user: User?
    var task: String?
    
    let ph = PaymentHandler()
    let duh = DatabaseUserHandler()
    let ch = CoreDataHandler()
    
    @IBOutlet weak var btnSave: UIButton!
    let paymentTextField = STPPaymentCardTextField()

    @IBOutlet weak var txtAmount: UITextField!
    @IBAction func save(sender: AnyObject) {
        let card = paymentTextField.cardParams
        STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
            if self.task! != "Edit"{
                if let error = error  {
                    print(error)
                    self.show("Invalid Card. Could not create payment with card used")
                } else if Int(self.txtAmount.text!)! < 5 || Int(self.txtAmount.text!)! > 5000{
                    self.show("Please enter a donation between 5 - 5000 per month")
                }else if let token = token {
                    let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
                    self.user?.userPlan = self.txtAmount.text
                    controller.user = self.user
                    controller.token = token
                    controller.task = "CreateUser"
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            } else{
                self.ph.changePaymentDetails(token!, uid: self.ch.getUserData().userID!, amount: self.txtAmount.text!, duh: self.duh, ch: self.ch)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        paymentTextField.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 30, 44)
        paymentTextField.delegate = self
        let stack = view.subviews[1] as! UIStackView
        stack.addArrangedSubview(paymentTextField)
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        btnSave.enabled = (textField.valid && txtAmount.text != "")
    }
}
