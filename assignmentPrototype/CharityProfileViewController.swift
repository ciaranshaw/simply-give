//
//  CharityProfileViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 3/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CharityProfileViewController: UIViewController {
    
    var charity: Charity?
    var userData: UserData?
    
    let duh = DatabaseUserHandler()
    let dch = DatabaseCharityHandler()
    let ch = CoreDataHandler()
    let ph = PortionHandler()
    
    let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabBarController
    
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCharityName: UILabel!
    @IBOutlet weak var lblTotalRaised: UILabel!
    @IBOutlet weak var lblSubscribers: UILabel!
    @IBOutlet weak var lblAbout: UITextView!
    
    @IBOutlet weak var btnSubscribe: UIButton!
    
    // When the user wants to subscribe to a charity
    @IBAction func btnSubscribe(sender: AnyObject) {
        if ch.isLoggedIn() {
            let ud = ch.getUserData()
            let newSubscribed = ud.userSubscribed!
            if btnSubscribe.currentTitle == "Subscribe"{
                newSubscribed.addObject((self.charity?.charityID)!)
                btnSubscribe.setTitle("Unsubscribe", forState: UIControlState.Normal)
                ch.updateSubscribed(ph, duh: duh, newCharityList: newSubscribed, task: "Add", charityIndex: newSubscribed.count - 1)
                dch.updateCharitiesSubscribed((self.charity?.charityID)!, userID: ch.getUserData().userID!, task: "Add")
                charity?.charitySubscribed = (charity?.charitySubscribed!)! + 1
                lblSubscribers.text = String("\(charity!.charitySubscribed!) Subscribers")
            } else {
                let index = newSubscribed.indexOfObject((self.charity?.charityID)!)
                newSubscribed.removeObjectAtIndex(index)
                newSubscribed
                btnSubscribe.setTitle("Subscribe", forState: UIControlState.Normal)
                ch.updateSubscribed(ph, duh: duh, newCharityList: newSubscribed, task: "Delete", charityIndex: index)
                dch.updateCharitiesSubscribed((self.charity?.charityID)!, userID: ch.getUserData().userID!, task: "Delete")
                charity?.charitySubscribed = (charity?.charitySubscribed!)! - 1
                lblSubscribers.text = String("\(charity!.charitySubscribed!) Subscribers")
            }
        } else{
            show("Please log in before attempting to subscribe")
        }
    }
    
    // When the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgCoverPhoto.image = UIImage(data: charity!.charityCoverPhoto!)
        imgLogo.image = UIImage(data: charity!.charityLogo!)
        lblCharityName.text = charity!.charityName
        lblTotalRaised.text = "Your donation : $ \(round(dch.getPersonalDonation(ch, charityID: charity!.charityID!) * 100) / 100)"
        lblSubscribers.text = String("\(charity!.charitySubscribed!) Subscribers")
        lblAbout.text = charity!.charityAbout
                
        if ch.isLoggedIn() {
            let ud = ch.getUserData()
            for item in ud.userSubscribed!{
                if item as! String == (charity?.charityID)!{
                    btnSubscribe.setTitle("Unsubscribe", forState: UIControlState.Normal)
                    break
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
