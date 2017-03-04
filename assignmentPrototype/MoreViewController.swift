//
//  MoreViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 1/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    var duh : DatabaseUserHandler?
    var lh : LoginHandler?
    var ch : CoreDataHandler?
    var mh: MailHandler?
    
    override func viewDidLoad() {
        duh = DatabaseUserHandler()
        lh = LoginHandler()
        ch = CoreDataHandler()
        mh = MailHandler()
        super.viewDidLoad()
        
        self.conformView("More")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.conformView("More")
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // When the user selects an object in the list view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            handleSimplyGive(indexPath.row)
        case 1:
            handlePortfolioManagement(indexPath.row)
            break
        case 2:
            handleProfileManagement(indexPath.row)
            break
        default:
            break
        }
    }
    
    // When the user wants to change their profile on the app
    func handleProfileManagement(row: Int){
        switch row{
        case 0:
            logout(self.ch!, duh: self.duh!)
            break
        case 1:
            deleteUser(self.ch!, duh: self.duh!)
            break
        default:
            break
        }
    }
    
    // When the user wants to look at options for the charity
    func handleSimplyGive(row: Int){
        switch row{
        case 0:
            viewAbout()
            break
        case 1:
            sendMail(self.mh!, context: self, subject: "Report a problem")
            break
        case 2:
            sendMail(self.mh!, context: self, subject: "Register charity enquiry")
            break
        default:
            break
        }
    }
    
    // When the user wants to update their portfolio
    func handlePortfolioManagement(row: Int){
        switch row{
        case 0:
            viewPortions()
            break
        case 1:
            editPortions()
            break
        case 2:
            updatePayment()
            break
        default:
            break
        }
    }
    
    // Function to send the mail
    func sendMail<T: UIViewController where T: MFMailComposeViewControllerDelegate>(mh: MailHandler, context: T, subject: String){
        let mailComposeViewController = mh.configuredMailComposeViewController(context, subject: subject)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.show("Cannot send email as you do not have access to a mail account!")
        }
    }
    
    // When the mail view has been closed, show message
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        if(result.rawValue == 2){
            self.show("Thank you for your help! We will be in touch shortly!", title: "Email Sent")
        }
    }
    
    // Logout of the account
    func logout(ch: CoreDataHandler, duh: DatabaseUserHandler){
        self.show("Are you sure you wish to logout?", btnTitle: "Logout", next: { x in
            self.lh!.logoutUser(self.ch!, duh: self.duh!)
            let profileNav = self.parentViewController?.parentViewController?.childViewControllers[2] as! ProfileNavigationController
            let controllerTwo = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoginController") as! ProfileViewController
            profileNav.setViewControllers([controllerTwo], animated: true)
            self.tableView.reloadData()
        })
    }
    
    // Get the password from the user then delete their details
    func deleteUser(ch: CoreDataHandler, duh: DatabaseUserHandler){
        self.confirmDelete({password in
            let profileNav = self.parentViewController?.parentViewController?.childViewControllers[2] as! ProfileNavigationController
            let controllerTwo = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoginController") as! ProfileViewController
            profileNav.setViewControllers([controllerTwo], animated: true)
            let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
            controller.password = password
            controller.task = "DeleteUser"
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    // View the about section of the app
    func viewAbout(){
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("About")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // View the portions
    func viewPortions(){
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
        controller.task = "CharityPortions"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Edit the user's portions
    func editPortions(){
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
        controller.task = "EditCharityPortions"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Update the payment details
    func updatePayment(){
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("PaymentViewController") as! PaymentViewController
        controller.task = "Edit"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // If the user is logged in, show all three table view sections, otherwise jus show one
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (ch?.isLoggedIn() == false){
            return 1
        }
        return 3
    }
    
}
