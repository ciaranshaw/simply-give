//
//  CharityPortionEditTableViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 8/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class CharityPortionEditTableViewController: UITableViewController {
    
    var charityNames: NSMutableArray?
    var portionAmounts: NSMutableArray?
    
    let ch = CoreDataHandler()
    let ph = PortionHandler()
    let duh = DatabaseUserHandler()
    var plan: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plan = Double(ch.getUserData().userPlan!)
    }
    
    override func viewDidAppear(animated: Bool) {
        if animated{
            self.navigationController?.navigationBar.items![0].hidesBackButton = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        duh.updatePortions(portionAmounts!, ch: ch)
    }
    
    @IBAction func clear(sender: AnyObject) {
        ph.clearPortions(portionAmounts!)
        tableView.reloadData()
        self.navigationItem.hidesBackButton = ph.checkEnabled(portionAmounts!)
    }
    
    @IBAction func generate(sender: AnyObject) {
        let x = ph.getZeroPortionsTotal(portionAmounts!)
        
        let zeroPortions = x.0
        let total: Double = x.1
        
        if zeroPortions.count == 0 && total < 1{
            ph.portionTooSmall(portionAmounts!, total: total)
        } else if zeroPortions.count != 0 && total < 1{
            ph.portionZero(portionAmounts!, zeroPortions: zeroPortions, total: total)
        } else if zeroPortions.count == 0 && total > 1{
            ph.portionTooLarge(portionAmounts!, total: total)
        } else{
            ph.portionTooLargeZero(portionAmounts!, total: total, zeroPortions: zeroPortions)
        }
        
        self.tableView.reloadData()
        self.navigationItem.hidesBackButton = ph.checkEnabled(portionAmounts!)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityNames!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PortionCell", forIndexPath: indexPath) as! CharityPortionEditTableViewCell
        
        let row = indexPath.row
        cell.row = row
        cell.vc = self
        
        let monthlyPercentage = Double(portionAmounts![indexPath.row] as! Double)
        let monthlyAmount = round((monthlyPercentage * plan!) * 100) / 100
        let percentage = Int(monthlyPercentage * 100)
        cell.lblCharityName.text = charityNames![row] as? String
        cell.lblPortionAmount.text = "$\(monthlyAmount) | \(percentage)%"
        cell.portionSlider.value = Float(monthlyPercentage)
        
        return cell
    }
}
