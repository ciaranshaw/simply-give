//
//  ProfileNavigationController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 24/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import CoreData
import UIKit

class ProfileNavigationController: UINavigationController, UITabBarControllerDelegate {
    
    var userData: UserData?

    // Load all data into the view
    // NOTE: View is made up of tab view controllers to view data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! TabBarController
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("UserData", inManagedObjectContext: root.managedObjectContext!)
        fetchRequest.entity = entityDescription
        
        var result = NSArray?()

        let controllerOne = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoadingScreen") as! LoadingScreen
        controllerOne.task = "Login"
        let controllerTwo = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("LoginController") as! ProfileViewController
        
        do{
            result = try root.managedObjectContext!.executeFetchRequest(fetchRequest)
            
            if result!.count != 0{
                let data = result![0] as! UserData
                controllerOne.userID = data.userID
                self.setViewControllers([controllerOne], animated: true)
            } else{
                self.setViewControllers([controllerTwo], animated: true)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
