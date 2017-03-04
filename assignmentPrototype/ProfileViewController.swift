//
//  ProfileViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/")
    let dh = DatabaseUserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conformView("Profile")
        txtEmail.keyboardType = UIKeyboardType.EmailAddress
        txtPassword.secureTextEntry = true
        activityIndicator.stopAnimating()
    }
    
    // When the user wants to login, verify that the information is correct and if it is, log them in
    @IBAction func btnLogin(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        btnLogin.hidden = true
        btnLogin.alpha = CGFloat(0)
        
        guard let email = txtEmail.text where isValidEmail(txtEmail.text!) else {
            show("Email Address is incorrectly formatted, please revise")
            return
        }
        
        dh.getUserIDLogin(email, password: txtPassword.text!,
            success: { auth in
                self.btnLogin.hidden = false
                let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
                controller.task = "Login"
                controller.userID = auth.uid
                self.navigationController?.pushViewController(controller, animated: true)
                self.activityIndicator.stopAnimating()
            },
            failure: {error in
                if error.code == -6{
                    self.show("Could not log user in. Invalid password.")
                } else if error.code == -8{
                    self.show("Could not log user in. Invalid email.")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.btnLogin.hidden = false
                self.btnLogin.alpha = CGFloat(1)
        })
    }
    
    // When the segue is sent to create user, go to register user screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "UserRegisterSegue"){
            let controller = segue.destinationViewController as! RegisterFirstViewController
            controller.task = "CreateUser"
        }
    }
    
    // Check that the email is correctly formatted
    
    // NOTE: Code obtained from SO post: http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}
