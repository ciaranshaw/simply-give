//
//  RegisterThirdViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase

class RegisterThirdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let duh = DatabaseUserHandler()
    
    var user: User?
    var task: String?
    
    let states = ["ACT", "TAS", "NT", "WA", "NSW", "VIC", "QLD", "SA"]
    
    @IBOutlet weak var txtStreetNumber: UITextField!
    @IBOutlet weak var txtStreetName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostcode: UITextField!
    @IBOutlet weak var pickerState: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerState.delegate = self
        pickerState.dataSource = self
        
        if(task == "Edit"){
            let address = user?.userAddress
            let num = address!.userStreetNumber!
            txtStreetNumber.text = String(num)
            txtStreetName.text = address?.userStreetName
            txtCity.text = address?.userCity
            txtPostcode.text = address?.userPostcode
            
            var defaultRowIndex = states.indexOf((address?.userState)!)
            if(defaultRowIndex == nil) { defaultRowIndex = 0 }
            pickerState.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        }
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterFirstViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "DevelopUserSegueThree" && self.task == "Edit"{
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
            getAddressDetails()
            controller.task = "FinishEditUser"
            controller.user = user
            self.navigationController?.pushViewController(controller, animated: true)
            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DevelopUserSegueThree"{
            
            getAddressDetails()
            
            let controller = segue.destinationViewController as! PaymentViewController
            controller.user = user
            controller.task = "Add"
        }
    }
    
    func getAddressDetails(){
        guard let streetNumber = txtStreetNumber.text where Int(txtStreetNumber.text!) != nil else{
            show("Please enter valid street number to register")
            return
        }
        guard let streetName = txtStreetName.text where txtStreetName.text?.characters.count > 0 else{
            show("Please enter street name to register")
            return
        }
        guard let city = txtCity.text where txtCity.text?.characters.count > 0 else{
            show("Please enter city to register")
            return
        }
        guard let postcode = txtPostcode.text where txtPostcode.text?.characters.count > 0 else{
            show("Please enter valid postcode to register")
            return
        }
        
        let state = states[pickerState.selectedRowInComponent(0)]
        
        user?.userAddress = Address(userStreetNumber: Int(streetNumber)!, userStreetName: streetName, userCity: city, userPostcode: postcode, userState: state)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
