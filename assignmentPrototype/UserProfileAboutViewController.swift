//
//  UserProfileAboutViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class UserProfileAboutViewController: UIViewController {
    
    var user: User?
    
    // Load the details of the user into the view controller with the correct format
    override func viewDidLoad() {
        super.viewDidLoad()
        let lblTitle = UILabel()
        lblTitle.text = "About"
        lblTitle.font = UIFont.boldSystemFontOfSize(17.0)
        lblTitle.sizeToFit()
        
        let lblAbout = UILabel()
        lblAbout.numberOfLines = 0
        lblAbout.preferredMaxLayoutWidth = self.view.frame.width - 30
        lblAbout.lineBreakMode = .ByWordWrapping
        lblAbout.text = user?.userAbout
        
        lblAbout.frame = CGRect(x: 0, y: lblTitle.frame.maxY + lblTitle.frame.height + 10, width: self.view.frame.width - 30, height: lblAbout.frame.height)
        lblAbout.sizeToFit()
        
        let scroll = self.view.subviews[0] as! UIScrollView
        scroll.addSubview(lblTitle)
        scroll.addSubview(lblAbout)
        
        scroll.contentSize = CGSize(width: self.view.frame.width - 30, height: lblAbout.frame.height + lblTitle.frame.height + 40)
        scroll.sizeToFit()
        
    }
    
    
}
