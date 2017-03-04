//
//  UserProfileViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UITabBarControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tabBarController?.delegate = self
    }
    
    var user: User?
    let ch = CoreDataHandler()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserSubscribed: UILabel!
    @IBOutlet weak var lblUserDonated: UILabel!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var subscribedView: UIView!
    @IBOutlet weak var paymentView: UIView!

    // Switch over the sub view controllers to decide which one to show
    @IBAction func swtUserProfile(sender: AnyObject) {
        
        switch(sender.selectedSegmentIndex){
        case 0:
            aboutView.hidden = false
            subscribedView.hidden = true
            paymentView.hidden = true
            break
        case 1:
            aboutView.hidden = true
            subscribedView.hidden = false
            subscribedView.reloadInputViews()
            paymentView.hidden = true
            break
        case 2:
            aboutView.hidden = true
            subscribedView.hidden = true
            paymentView.hidden = false
            break
        default:
            break
        }
    }
    
    // Edit functionality for when the user wants to change their details
    @IBAction func edit(sender: AnyObject) {
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
        controller.task = "StartEditUser"
        controller.userID = user?.userID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblUserName.text = (user?.userFirstName)! + " " + (user?.userLastName)!
        lblUserDonated.text = "$\(ch.getUserData().userPlan!) per month"
        lblUserSubscribed.text = "\(ch.getUserData().userSubscribed!.count) Subscribed"
        profileImage.image = UIImage(data: (user?.userProfilePicture)!)
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.blackColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        let controller = parentViewController?.parentViewController?.childViewControllers[2] as! ProfileNavigationController
        controller.viewControllers = [self]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.conformView("Profile")
        lblUserDonated.text = "$\(ch.getUserData().userPlan!) per month"
        lblUserSubscribed.text = "\(ch.getUserData().userSubscribed!.count) Subscribed"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When the user wants to view a subview, segue will be started, causing the tab bar to shuffle views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "About") {
            let controller = segue.destinationViewController as! UserProfileAboutViewController
            controller.user = user
            // Pass data to secondViewController before the transition
        } else if(segue.identifier == "Subscriptions"){
            let controller = segue.destinationViewController as! UserProfileSubscribedViewController
            controller.user = user
        } else if(segue.identifier == "Payment"){
            let controller = segue.destinationViewController as! UserProfilePaymentViewControler
            controller.user = user
        }
    }
}
