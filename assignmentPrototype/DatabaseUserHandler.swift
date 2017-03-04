//
//  DatabaseHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 30/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import Firebase

struct DatabaseUserHandler {
    
    // Name: userObjFromSnapshot
    // Param: snapshot: Firebase database snapshot contains the JSON to get the user, userID: userID of the user to return
    // Return: User object with data receieved from the snapshot
    // Purpose: Retrieve a user object from the firebase snapshot object
    func userObjFromSnapshot(snapshot: FDataSnapshot, userID: String) -> User{
        let userDictionary = snapshot.value[userID] as! NSDictionary
        let userDictionaryAddress = userDictionary["userAddress"] as! NSDictionary
        let address = Address(userStreetNumber: userDictionaryAddress["userStreetNumber"] as! Int, userStreetName: userDictionaryAddress["userStreetName"] as! String, userCity: userDictionaryAddress["userCity"] as! String, userPostcode: userDictionaryAddress["userPostcode"] as! String, userState: userDictionaryAddress["userState"] as! String)
        var userSubscribed = NSMutableArray()
        if(userDictionary["userSubscribed"] != nil){
            userSubscribed = userDictionary["userSubscribed"] as! NSMutableArray
        }
        var userSubscribedPortions = NSMutableArray()
        if(userDictionary["userSubscribedPortions"] != nil){
            userSubscribedPortions = userDictionary["userSubscribedPortions"] as! NSMutableArray
        }
        let user = User(userID: userID, userFirstName: userDictionary["userFirstName"] as! String, userLastName: userDictionary["userLastName"] as! String, userEmail: userDictionary["userEmail"] as! String, userAbout: userDictionary["userAbout"] as! String, userProfilePicture: NSData(base64EncodedString: userDictionary["userProfilePicture"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!, userAddress: address, userPlan: userDictionary["plan"] as! String, userSubscribed: userSubscribed, userSubscribedPortions: userSubscribedPortions)
        return user
    }
    
    // Name: userDictFromSnapshot
    // Param: Firebase database snapshot contains the JSON to get the user, userID: userID of the user to return
    // Return: NSDictionary containing user details
    // Purpose: Retrieve a dictionary of user details from a Firebase Snapshot
    func userDictFromSnapshot(snapshot: FDataSnapshot, userID: String) -> NSDictionary{
        return snapshot.value[userID] as! NSDictionary
    }
    
    // Name: userDictFromUser
    // Param: user: User object to get data from
    // Return: NSDictionary containing user details
    // Purpose: Retrieve a dictionary of user details from a user object
    func userDictFromUser(user: User) -> NSDictionary{
        let userFirstName = user.userFirstName
        let userLastName = user.userLastName
        let userEmail = user.userEmail
        let userAbout = user.userAbout
        let userProfilePicture = user.userProfilePicture?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let userAddress = addressDictFromAddress(user.userAddress!)
        let userPlan = user.userPlan
        
        return ["userFirstName": userFirstName!, "userLastName": userLastName!, "userEmail": userEmail!, "userAbout": userAbout!, "userProfilePicture": userProfilePicture!, "userAddress": userAddress, "stripeID": "", "plan": userPlan!]
    }
    
    // Name: addressDictFromAddress
    // Param: address: Address object to get data from
    // Return: NSDictionary containing address details
    // Purpose: Retrieve a dictionary of address details from an address object
    func addressDictFromAddress(address: Address) -> NSDictionary{
        let userStreetNumber = address.userStreetNumber
        let userStreetName = address.userStreetName
        let userCity = address.userCity
        let userPostcode = address.userPostcode
        let userState = address.userState
        
        return ["userStreetNumber": userStreetNumber!, "userStreetName": userStreetName!, "userCity": userCity!, "userPostcode": userPostcode!, "userState": userState!]
    }
    
    // Name: getUserObj
    // Param: uid: UserID of object to get, next: function to be executed once user has been recieved
    // Return: None
    // Purpose: Get a user object from the firebase database from a userID
    func getUserObj(uid: String, next: (user: User) -> Void) -> Void{
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users")
        firebase.queryOrderedByKey().queryEqualToValue(uid).observeSingleEventOfType(.Value, withBlock: {snapshot in
            let newUser = self.userObjFromSnapshot(snapshot, userID: uid)
            next(user: newUser)
        })
    }
    
    // Name: getUserDict
    // Param: uid: UserID of dictionary to get, next: function to be executed once dictionary has been recieved
    // Return: None
    // Purpose: Get a dictionary of user details from the database from a userID
    func getUserDict(uid: String, next: (newUser: NSDictionary) -> Void) -> Void{
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users")
        firebase.queryOrderedByKey().queryEqualToValue(uid).observeSingleEventOfType(.Value, withBlock: {snapshot in
            let newUser = self.userDictFromSnapshot(snapshot, userID: uid)
            next(newUser: newUser)
        })
    }
    
    // Name: createUser
    // Param: user: User object to add to database, context: The current view, next: function to be executed when the user has been created
    // Return: None
    // Purpose: Create a user obect using the user details
    func createUser(user: User, context: UIViewController, next: (uid: String) -> Void){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users")
        firebase.createUser(user.userEmail, password: user.userPassword, withValueCompletionBlock: { error, result in
            if error != nil{
                context.show("Email already associated with an account. Please use a different email, or select 'Forgot my password'")
                context.navigationController?.popToRootViewControllerAnimated(true)
            } else{
                self.saveUser(user, next: next)
            }
        })
    }
    
    // Name: saveUser
    // Param: user: User object to save to database, next: function to be executed once user has been saved
    // Return: None
    // Purpose: Save the user details to the database
    func saveUser(user: User, next: (uid: String) -> Void){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users")
        firebase.authUser(user.userEmail, password: user.userPassword) { (error, auth) in
            user.userID = auth.uid
            firebase.updateChildValues([auth.uid : self.userDictFromUser(user)], withCompletionBlock: {error in
                next(uid: auth.uid)
            })
        }
    }
    
    // Name: updateUser
    // Param: user: User object to update, userID: location of object to update
    // Return: None
    // Purpose: Update the user details in the database
    func updateUser(user: User, userID: String){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        firebase.updateChildValues(["userAddress": addressDictFromAddress(user.userAddress!)], withCompletionBlock: { error in
            firebase.updateChildValues(["userAbout": user.userAbout!], withCompletionBlock: { error in
                firebase.updateChildValues(["userFirstName": user.userFirstName!], withCompletionBlock: { error in
                    firebase.updateChildValues(["userLastName": user.userLastName!], withCompletionBlock: { error in
                        firebase.updateChildValues(["userProfilePicture": (user.userProfilePicture?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!])
                    })
                })
            })
        })
    }
    
    // Name: getUserIDLogin
    // Param: email: Email of current user, password: Password of current user, success: function to be executed when the AuthData is recieved
    // Return: None
    // Purpose: Get the user ID of the user based on their email and password
    func getUserIDLogin(email: String, password: String, success: (FAuthData) -> Void, failure: (NSError) -> Void) {
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com")
        firebase.authUser(email, password: password, withCompletionBlock: { error, auth in
            if error != nil{
                failure(error)
            } else {
                success(auth)
            }
        })
    }
    
    // Name: getUserPortions
    // Param: userID: userID of user to get portions from, next: function to execute once portions have been retrieved
    // Return: None
    // Purpose: Get the portion amounts of the user
    func getUserPortions(userID: String, next: (NSMutableArray) -> Void){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        firebase.queryOrderedByKey().queryEqualToValue("userSubscribedPortions").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let dict = snapshot.value as! NSDictionary
            let portions = dict["userSubscribedPortions"] as! NSArray
            let array = NSMutableArray(array: portions)
            next(array)
        })
    }
    
    // Name: deleteUser
    // Param: context: The view calling the method, password: The password entered by the user to delete account, ch: Core Data Handler, lh: Login Handler, duh: Database User Handler
    // Return: None
    // Purpose: Delete the user from the database
    func deleteUser(context: UIViewController, password: String, ch: CoreDataHandler, lh: LoginHandler, duh: DatabaseUserHandler){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com")
        self.logout()
        let uid = ch.getUserData().userID
        self.getUserObj(uid!, next: {user in
            firebase.removeUser(user.userEmail, password: password, withCompletionBlock: {error in
                if error != nil{
                    if(error.code == -6){
                        context.show("Could not delete account with incorrect password. You have been logged out")
                    }
                } else{
                    let ref = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(uid)")
                    ref.removeValue()
                }
            })
        })
        lh.logoutUser(ch, duh: duh)
    }
    
    // Name: updateDatabaseSubscribed
    // Param: userID: userID of subscribed list to update, subscribed: the new list of subscribed charities, task: Add or Delete option, charityIndex: The index of the charity being updated, ch: Core Data Handler, ph: Portion Handler
    // Return: None
    // Purpose: Update the subscribed array of the user
    func updateDatabaseSubscribed(userID: String, subscribed: NSMutableArray, task: String, charityIndex: Int, ch: CoreDataHandler, ph: PortionHandler){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        let returnArray = subscribed as NSArray
        print(returnArray)
        firebase.updateChildValues(["userSubscribed" : returnArray])
        updateSubscribedPortions(userID, subscribed: returnArray, task: task, charityIndex: charityIndex, ch: ch, ph: ph)
    }
    
    // Name: updateSubscribedPortions
    // Param: userID: userID of subscribed list to update, subscribed: the new list of subscribed charities, task: Add or Delete option, charityIndex: The index of the charity being updated, ch: Core Data Handler, ph: Portion Handler
    // Return: None
    // Purpose: Update the subscribed portions of a user
    func updateSubscribedPortions(userID: String, subscribed: NSArray, task: String, charityIndex: Int, ch: CoreDataHandler, ph: PortionHandler){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        let array: NSArray?
                
        if subscribed.count == 1{
            array = [1]
        } else if subscribed.count == 0{
            array = []
        } else{
            if task == "Add"{
                array = ph.addSubscribedPortion(ch.getUserData().userSubscribedPortions!)
            } else{
                array = ph.deleteSubscribedPortion(ch.getUserData().userSubscribedPortions!, charityIndex: charityIndex)
            }
        }
        ch.updatePortions(NSMutableArray(array:array!))
        ch.save()
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        let more = root.childViewControllers[3].childViewControllers[0] as! MoreViewController
        more.navigationController?.popViewControllerAnimated(false)
        firebase.updateChildValues(["userSubscribedPortions" : array!])
    }
    
    // Name: updatePaymentInformation
    // Param: plan: The new plan to be updated, userID: userID of user to update payment, ch: Core Data Handler
    // Return: None
    // Purpose: update the payment information of a user
    func updatePaymentInformation(plan: String, userID: String, ch: CoreDataHandler){
        ch.updatePlan(plan)
        
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        firebase.updateChildValues(["plan": plan])
    }
    
    // Name: updatePortions
    // Param: portions: list of new portions to update, ch: Core Data Handler
    // Return: None
    // Purpose: Update the portions array for the user
    func updatePortions(portions: NSMutableArray, ch: CoreDataHandler){
        ch.updatePortions(portions)
        
        let userID = ch.getUserData().userID!
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com/users/\(userID)")
        let p = NSArray(array: portions)
        firebase.updateChildValues(["userSubscribedPortions": p])
    }
    
    // Name: logout
    // Param: None
    // Return: None
    // Purpose: Log the user out of the firebase auth system
    func logout(){
        let firebase = Firebase(url: "https://finalassignmentprot.firebaseio.com")
        firebase.unauth()
    }
    
}
