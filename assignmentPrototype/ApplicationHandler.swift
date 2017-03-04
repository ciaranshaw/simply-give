//
//  ApplicationHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 30/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import Firebase

class ApplicationHandler{
    
    func userFromSnapshot(snapshot: FDataSnapshot) -> User{
        let userDictionary = snapshot.value[self.userID!] as! NSDictionary
        let userDictionaryAddress = userDictionary["userAddress"] as! NSDictionary
        let address = Address(userStreetNumber: userDictionaryAddress["userStreetNumber"] as! Int, userStreetName: userDictionaryAddress["userStreetName"] as! String, userCity: userDictionaryAddress["userCity"] as! String, userPostcode: userDictionaryAddress["userPostcode"] as! String, userState: userDictionaryAddress["userState"] as! String)
        let user = User(userFirstName: userDictionary["userFirstName"] as! String, userLastName: userDictionary["userLastName"] as! String, userEmail: userDictionary["userEmail"] as! String, userAbout: userDictionary["userAbout"] as! String, userProfilePicture: NSData(base64EncodedString: userDictionary["userProfilePicture"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!, userAddress: address)
        return user
    }
    
}
