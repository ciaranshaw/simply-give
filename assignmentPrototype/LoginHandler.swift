//
//  LoginHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 30/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import UIKit

struct LoginHandler {
    
    // Name: loginUser
    // Param: ch: Core Data Handler to handle the core data, and the user object to be logged in
    // Return: None
    // Purpose: To update the user data in the app to the user data retrieved from the DB
    func loginUser(ch: CoreDataHandler, user: User){
        let userData: UserData?
        
        if(ch.isLoggedIn()){
            userData = hasBeenLoggedIn(ch)
        } else {
            userData = notBeenLoggedIn(ch)
        }
        
        userData?.userID = user.userID
        userData?.userSubscribed = user.userSubscribed
        userData?.userPlan = user.userPlan
        userData?.userSubscribedPortions = user.userSubscribedPortions
        
        ch.save()
    }
    
    // Name: hasBeenLoggedIn
    // Param: ch, Core Data Handler
    // Return: The user data stored in core data
    // Purpose: To get the user data for someone who is logged in
    func hasBeenLoggedIn(ch: CoreDataHandler) -> UserData {
        return ch.getUserData()
    }
    
    // Name: notBeenLoggedIn
    // Param: ch, Core Data Handler
    // Return: The user data stored in core data
    // Purpose: To get the user data for someone who is not logged in
    func notBeenLoggedIn(ch: CoreDataHandler) -> UserData {
        return ch.createUserData()
    }
    
    // Name: logoutUser
    // Param: ch, Core Data Handler and duh, the Database User Handler
    // Return: None
    // Purpose: Log the user out of the app, and the website
    func logoutUser(ch: CoreDataHandler, duh: DatabaseUserHandler){
        duh.logout()
        ch.deleteUserData()
    }
    
    
}