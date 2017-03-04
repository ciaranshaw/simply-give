//
//  CharityPortionEditTableViewCell.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 8/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class CharityPortionEditTableViewCell: UITableViewCell {
    
    var row: Int?
    var vc: CharityPortionEditTableViewController?
    let ch = CoreDataHandler()
    let ph = PortionHandler()
    
    @IBOutlet weak var lblCharityName: UILabel!
    @IBOutlet weak var lblPortionAmount: UILabel!
    @IBOutlet weak var portionSlider: UISlider!
    
    @IBAction func sliderChanged(sender: AnyObject) {
        // Assign new values
        portionSlider.setValue(round((portionSlider.value) * 100) / 100, animated: true)
        let sliderValue = portionSlider.value
        
        let plan = Double(ch.getUserData().userPlan!)
        
        lblPortionAmount.text = "$\(round((Double(sliderValue) * plan!) * 100) / 100) | \(Int(sliderValue * 100))%"
        vc?.portionAmounts![row!] = sliderValue
        
        vc?.navigationItem.hidesBackButton = ph.checkEnabled((vc?.portionAmounts)!)
    }
}
