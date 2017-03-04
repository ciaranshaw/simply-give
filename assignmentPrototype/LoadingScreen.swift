//
//  LogUserIn.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 16/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import Stripe

class LoadingScreen: UIViewController {
    
    let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabBarController
    
    let ch = CoreDataHandler()
    let lh = LoginHandler()
    let dh = DatabaseUserHandler()
    let ph = PaymentHandler()
    let dch = DatabaseCharityHandler()
    let duh = DatabaseUserHandler()

    var userID: String?
    var task: String?
    var token: STPToken?
    var user: User?
    var password: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        activityIndicator.startAnimating()
        
        switch task!{
        case "Login":
            loginUser(userID!)
            break
        case "StartEditUser":
            startEditingUser(userID!, sender: "Normal")
            break
        case "CreateUser":
            createUser(user!, token: token!)
            break
        case "FinishEditUser":
            finishEditingUser((user?.userID)!, user: user!)
            break
        case "DeleteUser":
            deleteUser(password!, context: self)
            break
        case "CharityPortions":
            getCharityPortions()
            break
        case "EditCharityPortions":
            editCharityPortions()
            break
        default:
            break
        }
    }
    
    // Load the screen for the user to login, and using the user ID, log them into the app
    func loginUser(userID: String){
        self.conformView("Logging In")
        self.lblTitle.text = "Logging In"
        dh.getUserObj(userID, next: { user in
            self.lh.loginUser(self.ch, user: user)
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            controller.user = user
            self.navigationController?.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
        })
    }
    
    // Create the user, in both the database and the payment handler
    func createUser(user: User, token: STPToken){
        self.conformView("Creating User")
        self.lblTitle.text = "Creating User"
        dh.createUser(user, context: self, next: {uid in
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
            controller.userID = uid
            controller.task = "Login"
            self.navigationController?.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
            
            self.ph.createBackendChargeWithToken(self.token!, uid: self.user!.userID!, amount: (self.user?.userPlan)!, user: self.user!, completion: {status in
                print(status.rawValue)
            })
        })
    }
    
    // Begin editing the user 
    func startEditingUser(userID: String, sender: String){
        self.conformView("Getting User")
        self.lblTitle.text = "Getting User"
        dh.getUserObj(userID, next: {user in
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("RegisterFirstViewController") as! RegisterFirstViewController
            controller.editedUser = user
            controller.task = "Edit"
            self.navigationController?.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
        })
    }
    
    // Finish editing the user, and update their information
    func finishEditingUser(userID: String, user: User){
        self.conformView("Updating User")
        self.lblTitle.text = "Updating User"
        dh.updateUser(user, userID: userID)
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
        controller.user = user
        self.navigationController?.pushViewController(controller, animated: true)
        self.activityIndicator.stopAnimating()
    }
    
    // Delete user from both ch and duh
    func deleteUser(password: String, context: UIViewController){
        self.conformView("Deleting User")
        self.lblTitle.text = "Deleting User"
        dh.deleteUser(context, password: password, ch: self.ch, lh: self.lh, duh: self.dh)
        self.activityIndicator.stopAnimating()
        let navController = root.childViewControllers[3] as! UINavigationController
        navController.popToRootViewControllerAnimated(true)
        let c = navController.childViewControllers[0] as! MoreViewController
        c.tableView.reloadData()
    }
    
    // Get the charity portions for a user
    func getCharityPortions(){
        let ud = ch.getUserData()
        self.conformView("Calculating Portions")
        self.lblTitle.text = "Calculating Portions"
        dch.getCharityNamesFromIDList(ud.userSubscribed!, next: {charities in
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("CharityPortionTableViewController") as! CharityPortionTableViewController
            controller.charityNames = charities
            controller.portionAmounts = self.ch.getUserData().userSubscribedPortions
            self.activityIndicator.stopAnimating()
            
            let more = self.navigationController?.viewControllers[0]
            self.navigationController?.popViewControllerAnimated(false)
            more?.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    // Get and then edit the portions for a user
    func editCharityPortions(){
        let ud = ch.getUserData()
        self.conformView("Calculating Portions")
        self.lblTitle.text = "Calculating Portions"
        dch.getCharityNamesFromIDList(ud.userSubscribed!, next: {charities in
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("CharityPortionEditTableViewController") as! CharityPortionEditTableViewController
            controller.charityNames = charities
            controller.portionAmounts = ud.userSubscribedPortions
            self.activityIndicator.stopAnimating()
            
            print(ud.userSubscribed)
            print(ud.userSubscribedPortions)
            
            
            let more = self.navigationController?.viewControllers[0]
            self.navigationController?.popViewControllerAnimated(false)
            more?.navigationController?.pushViewController(controller, animated: true)

        })
    }
}
