//
//  Create User View Controller.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 16/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import Stripe

class Create_User_View_Controller: UIViewController{
    
    var user: User?
    var token: STPToken?
    
    let dh = DatabaseUserHandler()
    let ph = PaymentHandler()
    
    var firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/")
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newAddress: NSDictionary?
    var newUser: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.conformView("Creating User")
        
        activityIndicator.startAnimating()
        
        dh.createUser(user!, context: self, next: {uid in
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LogUserIn") as! LogUserIn
            controller.userID = uid
            self.navigationController?.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
            
            self.ph.createBackendChargeWithToken(self.token!, uid: self.user!.userID!, amount: (self.user?.userPlan)!, user: self.user!, completion: {status in
                print(status.rawValue)
            })
            
        })
        
    }
}
