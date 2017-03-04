//
//  DatabaseCharityHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 31/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import Firebase

struct DatabaseCharityHandler{

    // Name: getCharitiesInBlocks
    // Param: cellsLoaded: An int representing the total cells loaded so far, blocksize: The amount of charities to be returned, next: A function to be compeleted when block of charities has been loaded
    // Return: None
    // Purpose: To get the next block of charities in a sequential list
    func getCharitiesInBlocks(cellsLoaded: Int, blockSize: UInt, next: (charities: NSMutableArray) -> Void){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/charities")
        firebase.queryOrderedByKey().queryStartingAtValue(convertToID(cellsLoaded + 1)).queryLimitedToFirst(blockSize).observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            let returnCharities = NSMutableArray()
            
            let charities = snapshot.children as NSEnumerator
            for item in charities{
                let child = item as! FDataSnapshot
                let charityData = child.value as! NSDictionary
                returnCharities.addObject(self.charityFromDictionary(charityData))
            }
            next(charities: returnCharities)
        })
    }
    
    // Name: charityFromDictionary
    // Param: charityData: The dictionary representing the data of the charity
    // Return: Charity object containing the dictionary data passed in
    // Purpose: To get a charity object from a dicitonary containing charity data
    func charityFromDictionary(charityData: NSDictionary) -> Charity {
        let charityID = charityData["charityID"] as! String!
        let charityName = charityData["charityName"] as! String
        let charityDesc = charityData["charityDesc"] as! String
        let charityLogo = NSData(base64EncodedString: charityData["charityLogo"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let charityCover = NSData(base64EncodedString: charityData["charityCover"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let charitySubscribed = charityData["charitySubscribed"] as! Int
        let charityTotalDonated = charityData["charityTotalDonated"] as! Float
        let charityAbout = charityData["charityAbout"] as! String
        let charityCategory = charityData["charityCategory"] as! String
        let charity = Charity(charityID: charityID, charityName: charityName, charityDesc: charityDesc, charityLogo: charityLogo!, charityCoverPhoto: charityCover!, charitySubscribed: charitySubscribed, charityTotalDonated: charityTotalDonated, charityAbout: charityAbout, charityCategory: charityCategory)
        return charity
    }
    
    // Name: searchCharities
    // Param: searchTerm: The string searched by the user, allCharities: An array of all the charities in the system, next: The function to be completed once the search results have been found
    // Return: None
    // Purpose: To get a list of charities from a search by the user
    func searchCharities(searchTerm: String, allCharities: NSMutableArray, next: (searchResults: NSMutableArray) -> Void){
        
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/charities")
        
        firebase.queryOrderedByKey().observeSingleEventOfType(.Value, withBlock:{snapshot in
            let charities = snapshot.children as NSEnumerator
            if allCharities.count == 0{
                for item in charities{
                    let child = item as! FDataSnapshot
                    let charityData = child.value as! NSDictionary
                    allCharities.addObject(self.charityFromDictionary(charityData))
                }
            }
            let searchedCharities = NSMutableArray()
            for c in allCharities{
                let c = c as! Charity
                let name = c.charityName!
                let category = c.charityCategory!
                if name.lowercaseString.rangeOfString(searchTerm.lowercaseString) != nil || category.lowercaseString.rangeOfString(searchTerm.lowercaseString) != nil{
                    searchedCharities.addObject(c)
                }
            }
            next(searchResults: searchedCharities)
        
        })
    }
    
    // Name: getCharitiesFromIDList
    // Param: charityIDs: A list of the charityIDs to get charity list from, next: The function to be run once the list of charities has been recieved
    // Return: None
    // Purpose: To get a list of charity objects from a list of charityIDs
    func getCharitiesFromIDList(charityIDs: NSMutableArray, next: (NSMutableArray) -> Void){
        let charities = NSMutableArray()
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/charities")
        firebase.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let dict = snapshot.value as! NSDictionary
            for id in charityIDs {
                let x = id as! String
                let charityData = dict[x] as! NSDictionary
                
                charities.addObject(self.charityFromDictionary(charityData))
            }
            next(charities)
        })
    }
    
    // Name: getCharityNamesFromIDList
    // Param: charityIDs: List of charityIDs to get the charityNames from, next: The function to be run once the list of charities has been recieved
    // Return: None
    // Purpose: To get a list of charity names from a list of charityIDs
    func getCharityNamesFromIDList(charityIDs: NSMutableArray, next: (charities: NSMutableArray) -> Void){
        let charities = NSMutableArray()
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/charities")
        firebase.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let dict = snapshot.value as! NSDictionary
            for id in charityIDs {
                let x = id as! String
                let charityData = dict[x] as! NSDictionary
                charities.addObject(charityData["charityName"]!)
            }
            next(charities: charities)
        })
    }
    
    // Name: updateCharitiesSubscribed
    // Param: charityID: The charity to update the subscribed for, userID: The userID to update in the subcribed, task: Add or delete
    // Return: None
    // Purpose: To update the subscribed value of a specified charity
    func updateCharitiesSubscribed(charityID: String, userID: String, task: String){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/charities/\(charityID)")
        firebase.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let charityData = snapshot.value
            var subscribed = charityData!["charitySubscribed"] as? Int
            if task == "Add"{
                subscribed = subscribed! + 1
            } else {
                subscribed = subscribed! - 1
            }
            firebase.updateChildValues(["charitySubscribed": subscribed!])
        })
    }
    
    // Name: getPersonalDonation
    // Param: ch: Core Data Handler, charityID: The charity to get the donation from
    // Return: Double containg the amount that has been donated by the user to that charity
    // Purpose: To get the donation amount of the current user to a specific charity
    func getPersonalDonation(ch: CoreDataHandler, charityID: String) -> Double{
        if ch.isLoggedIn(){
            let subscribed = ch.getUserData().userSubscribed
            let portions = ch.getUserData().userSubscribedPortions
            
            let x = subscribed?.indexOfObject(charityID)
            if x < 20000{
                return Double(portions![x!] as! NSNumber) * Double(ch.getUserData().userPlan!)!
            }
        }
        return 0
    }
    
    // Name: addCharitySubscribed
    // Param: userID: The user to add to the subscribed list, subscribed: The current list of subscribed users
    // Return: Array of the current charities the user is subscribed to
    // Purpose: To add a charity to the list of subscribed charities
    func addCharitySubscribed(userID: String, subscribed: NSArray) -> NSArray{
        let x = NSMutableArray(array: subscribed)
        x.addObject(userID)
        return NSArray(array: x)
    }
    
    // Name: deleteCharitySubscribed
    // Param: userID: The user to delete from the subscribed list, subscribed: The current list of subscribed users
    // Return: Array of the current charities the user is subscribed to
    // Purpose: To delete a charity from the list of subscribed charities
    func deleteCharitySubscribed(userID: String, subscribed: NSArray) -> NSArray{
        let x = NSMutableArray(array: subscribed)
        x.removeObject(userID)
        return NSArray(array: x)
    }
  
    
    // Name: convertToID
    // Param: num: The integer to turn into a charityID String
    // Return: String containing the ID of the charity
    // Purpose: To convert an int representing the charity to a charity ID
    func convertToID(num: Int) -> String{
        var returnString = String(num)
        while returnString.characters.count < 8{
            returnString = "0" + returnString
        }
        return returnString
    }
    
}