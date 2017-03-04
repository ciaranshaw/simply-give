//
//  CharityPortionTableViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 8/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class CharityPortionTableViewController: UITableViewController {
    
    var charityNames: NSMutableArray?
    var portionAmounts: NSMutableArray?
    
    let ch = CoreDataHandler()
    let dch = DatabaseCharityHandler()
    let duh = DatabaseUserHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = "More"
    }
    
    override func viewWillAppear(animated: Bool) {
        if ch.isLoggedIn(){
            let ud = ch.getUserData()
            dch.getCharityNamesFromIDList(ud.userSubscribed!, next: {charities in
                self.charityNames = charities
                self.portionAmounts = self.ch.getUserData().userSubscribedPortions
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(charityNames!.count)
        return charityNames!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(57.0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PortionCell", forIndexPath: indexPath) as! CharityPortionTableViewCell
        
        let plan = Double(ch.getUserData().userPlan!)
        let monthlyPercentage = Double(portionAmounts![indexPath.row] as! Double)
        let monthlyAmount = round((monthlyPercentage * plan!) * 100) / 100
        cell.lblCharityName.text = charityNames![indexPath.row] as? String
        cell.lblPortionAmount.text = "$\(monthlyAmount) | \(round((monthlyPercentage * 100) * 100) / 100)%"
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Charity Portions"
    }
    
}
