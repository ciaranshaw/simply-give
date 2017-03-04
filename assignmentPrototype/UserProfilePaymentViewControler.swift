//
//  UserProfilePaymentViewControler.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class UserProfilePaymentViewControler: UIViewController {
    
    var user: User?
    let mh = MailHandler()
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBAction func btnSendTaxReciept(sender: AnyObject) {
        mh.sendPDFMail((user?.userID)!)
        self.show("Your report has been sent to email address: \((user?.userEmail!)!)", title: "Report Sent")
    }
    
    override func viewDidLoad() {
        lblEmail.text = user?.userEmail
        lblAddress.text = user?.userAddress?.toString()
        lblAddress.numberOfLines = 0
        lblAddress.lineBreakMode = .ByWordWrapping
        lblAddress.sizeToFit()
    }

}
