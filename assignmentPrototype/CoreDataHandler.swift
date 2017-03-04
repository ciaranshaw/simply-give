//
//  CoreDataHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 30/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHandler {
    
    // Root variable to access the core data object
    let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabBarController
    
    // Name: getUserData
    // Param: None
    // Return: UserData object that has been stored
    // Purpose: To get the user data stored currently in core data
    func getUserData() -> UserData{
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("UserData", inManagedObjectContext: root.managedObjectContext!)
        fetchRequest.entity = entityDescription
        var result = NSArray()
        do{
            result = try root.managedObjectContext!.executeFetchRequest(fetchRequest)
            if(result.count == 0){
                return UserData()
            } else{
                return result[0] as! UserData
            }
        } catch{
            return UserData()
        }
    }
    
    // Name: createUserData
    // Param: None
    // Return: UserData object that has been created and stored
    // Purpose: Creates blank user and returns it to caller
    func createUserData() -> UserData {
        let newUser: UserData = (NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: root.managedObjectContext!) as? UserData)!
        return newUser
    }
    
    // Name: isLoggedIn
    // Param: None
    // Return: Boolean to represent whether the user is logged in
    // Purpose: Checks if the user is currently logged into the app
    func isLoggedIn() -> Bool {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("UserData", inManagedObjectContext: root.managedObjectContext!)
        fetchRequest.entity = entityDescription
        var result = NSArray()
        
        do {
            result = try root.managedObjectContext!.executeFetchRequest(fetchRequest)
            return result.count != 0
        } catch {
            print(error)
        }
        return false
    }
    
    // Name: deleteUserData
    // Param: None
    // Return: None
    // Purpose: Delete the user currently stored in core data
    func deleteUserData(){
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("UserData", inManagedObjectContext: root.managedObjectContext!)
        fetchRequest.entity = entityDescription
        do{
            let userData = try root.managedObjectContext!.executeFetchRequest(fetchRequest)[0] as! UserData
            root.managedObjectContext?.deleteObject(userData)
            self.save()
        } catch{
            print(error)
        }
    }
    
    // Name: updateSubscribed
    // Param: ph: Portion Handler, duh: Database User Handler, newCharityList: A list of the charitiess to update, task: Add or Delete, charityIndex: The index of the charity that is being updated
    // Return: None
    // Purpose: Update the subscribed charities for a user in both the core data and database
    func updateSubscribed(ph: PortionHandler, duh: DatabaseUserHandler, newCharityList: NSMutableArray, task: String, charityIndex: Int){
        let ud = self.getUserData()
        ud.userSubscribed = newCharityList
        self.save()
        duh.updateDatabaseSubscribed(ud.userID!, subscribed: newCharityList, task: task, charityIndex: charityIndex, ch: self, ph: ph)
    }
    
    // Name: updatePortions
    // Param: newPortionsList: A list of the portions to update
    // Return: None
    // Purpose: Update the list of portions in the core data
    func updatePortions(newPortionsList: NSMutableArray){
        let ud = self.getUserData()
        ud.userSubscribedPortions = newPortionsList
        self.save()
    }
    
    // Name: updatePlan
    // Param: newPlan: A string that is the new plan amount
    // Return: None
    // Purpose: Update the user plan in core data
    func updatePlan(newPlan: String){
        let ud = self.getUserData()
        ud.userPlan = newPlan
        self.save()
    }
    
    // Name: save
    // Param: None
    // Return: None
    // Purpose: Save the current core data state
    func save(){
        do {
            try root.managedObjectContext!.save()
        } catch {
            print("Unresolved error")
            abort()
        }
    }
}
