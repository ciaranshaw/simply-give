//
//  User.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 4/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var userID: String?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userAbout: String?
    var userProfilePicture: NSData?
    var userSubscribed: NSMutableArray?
    var userSubscribedPortions: NSMutableArray?
    var userAddress: Address?
    var userPassword: String?
    var userPlan: String?
    
    init(userID: String, userFirstName: String, userLastName: String, userEmail: String, userAbout: String, userProfilePicture: NSData, userAddress: Address, userPassword: String, userPlan: String, userSubscribed: NSMutableArray, userSubscribedPortions: NSMutableArray){
        
        self.userID = userID
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userEmail = userEmail
        self.userAbout = userAbout
        self.userProfilePicture = userProfilePicture
        self.userSubscribed = userSubscribed
        self.userSubscribedPortions = userSubscribedPortions
        self.userAddress = userAddress
        self.userPassword = userPassword
        self.userPlan = userPlan
        
    }
    
    init(userID: String, userFirstName: String, userLastName: String, userEmail: String, userAbout: String, userProfilePicture: NSData, userAddress: Address, userPlan: String, userSubscribed: NSMutableArray, userSubscribedPortions: NSMutableArray){
        
        self.userID = userID
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userEmail = userEmail
        self.userAbout = userAbout
        self.userProfilePicture = userProfilePicture
        self.userSubscribed = userSubscribed
        self.userSubscribedPortions = userSubscribedPortions
        self.userAddress = userAddress
        self.userPlan = userPlan
    }

}
