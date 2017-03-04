//
//  ViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 12/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController{
    func conformView(title: String) {
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.topItem!.title = title
    }
    
    // Create a function to show an error message
    func show(errorMessage: String){
        // Create the alert and set the message to the error message provided
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        // Set the dismiss button to OK
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        // Show the alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Create a function to show an error message
    func show(errorMessage: String, title: String){
        // Create the alert and set the message to the error message provided
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        // Set the dismiss button to OK
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        // Show the alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Create a function to show an error message
    func show(errorMessage: String, btnTitle: String, next: (UIAlertAction) -> Void){
        // Create the alert and set the message to the error message provided
        let alertController = UIAlertController(title: "Logout", message: errorMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        // Set the dismiss button to OK
        alertController.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.Default,handler: next))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        // Show the alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmDelete(next: (password: String) -> Void){
        // Create the alert and set the message to the error message provided
        let alertController = UIAlertController(title: "Delete Account", message: "Enter password to delete account", preferredStyle:
            UIAlertControllerStyle.Alert)
        // Set the dismiss button to On
        alertController.addTextFieldWithConfigurationHandler({ textField in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            next(password: loginTextField.text!)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        // Show the alert
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

