//
//  Charity.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 4/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation

class Charity: NSObject{
    
    var charityID: String?
    var charityName: String?
    var charityDesc: String?
    var charityLogo: NSData?
    var charityCoverPhoto: NSData?
    var charitySubscribed: Int?
    var charityTotalDonated: Float?
    var charityAbout: String?
    var charityCategory: String?
    
    init(charityID: String, charityName: String, charityDesc: String, charityLogo: NSData, charityCoverPhoto: NSData, charitySubscribed: Int, charityTotalDonated: Float, charityAbout: String, charityCategory: String){
        
        self.charityID = charityID
        self.charityName = charityName
        self.charityDesc = charityDesc
        self.charityLogo = charityLogo
        self.charityCoverPhoto = charityCoverPhoto
        self.charitySubscribed = charitySubscribed
        self.charityTotalDonated = charityTotalDonated
        self.charityAbout = charityAbout
        self.charityCategory = charityCategory
        
    }
    
}
