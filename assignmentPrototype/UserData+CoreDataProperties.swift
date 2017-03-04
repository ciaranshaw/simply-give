//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by Ciaran Shaw on 24/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserData {

    @NSManaged var userID: String?
    @NSManaged var userSubscribed: NSMutableArray?
    @NSManaged var userPlan: String?
    @NSManaged var userSubscribedPortions: NSMutableArray?

}
