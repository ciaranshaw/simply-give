//
//  RegisterFirstViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class RegisterFirstViewController: UIViewController {
    
    var editedUser: User?
    var task: String?
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DevelopUserSegue"{
            guard let firstName = txtFirstName.text where txtFirstName.text?.characters.count > 0 else{
                show("Please enter first name to register")
                return
            }
            guard let lastName = txtLastName.text where txtLastName.text?.characters.count > 0 else{
                show("Please enter last name to register")
                return
            }
            guard let email = txtEmail.text where isValidEmail(txtEmail.text!) else{
                show("Please enter a valid email address")
                return
            }
            
            guard let password = txtPassword.text where isValidPassword(txtPassword.text!) || task == "Edit" else{
                show("Please enter a valid password (8 Characters with least one numeric character")
                return
            }
            
            guard let about = txtAbout.text where txtFirstName.text?.characters.count > 0 else{
                show("Please enter an about description to register")
                return
            }
            
            let controller = segue.destinationViewController as! RegisterSecondViewController
            
            if task == "Edit"{
                editedUser?.userFirstName = firstName
                editedUser?.userLastName = lastName
                editedUser?.userAbout = about
                controller.user = editedUser
                controller.task = "Edit"
            } else {
                let user = User(userID: "", userFirstName: firstName, userLastName: lastName, userEmail: email, userAbout: about, userProfilePicture: NSData(), userAddress: Address(), userPassword: password, userPlan: "", userSubscribed: NSMutableArray(), userSubscribedPortions: NSMutableArray())
                controller.user = user
            }
         }
        
    }
    
    override func viewDidLoad() {
        txtEmail.keyboardType = UIKeyboardType.EmailAddress
        txtPassword.secureTextEntry = true
        txtAbout.layer.borderWidth = 1.0
        txtAbout.layer.cornerRadius = 5
        txtAbout.layer.borderColor = txtEmail.layer.borderColor
        
        if self.task! == "Edit"{
            self.navigationItem.setHidesBackButton(true, animated: true)
            
            txtEmail.text = editedUser?.userEmail
            txtEmail.enabled = false
            txtPassword.text = editedUser?.userPassword
            txtPassword.enabled = false
            
            txtFirstName.text = editedUser?.userFirstName
            txtLastName.text = editedUser?.userLastName
            txtAbout.text = editedUser?.userAbout
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterFirstViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPassword(password: String) -> Bool {
        if password.characters.count < 8 { return false }
        if password.rangeOfCharacterFromSet(.letterCharacterSet(), options: .LiteralSearch, range: nil) == nil { return false }
        if password.rangeOfCharacterFromSet(.decimalDigitCharacterSet(), options: .LiteralSearch, range: nil) == nil { return false }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
