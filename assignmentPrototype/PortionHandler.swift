//
//  PortionHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 11/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation

struct PortionHandler{
    
    // Name: clearPortions
    // Param: portionAmounts: An array of the current portions for the user
    // Return: None
    // Purpose: To clear all portions in list
    func clearPortions(portionAmounts: NSMutableArray){
        var i = 0
        for _ in portionAmounts{
            portionAmounts[i] = 0
            i = i + 1
        }
    }
    
    // Name: portionTooSmall
    // Param: portionAmounts: An array of the current portions for the user, total: The current total of all the portions added together
    // Return: None
    // Purpose: To portion when the total < 0 and there are no zero portions
    func portionTooSmall(portionAmounts: NSMutableArray, total: Double){
        let amount = (1 - total) / Double(portionAmounts.count)
        var i = 0
        for portion in portionAmounts{
            let p = portion as! Double
            portionAmounts[i] = p + amount
            i = i + 1
        }
        portionExtra(1 - getTotal(portionAmounts), portionAmounts: portionAmounts)
    }
    
    // Name: portionTooLarge
    // Param: portionAmounts: An array of the current portions for the user, total: The current total of all the portions added together
    // Return: None
    // Purpose: To portion when total is > 1 and there are no zero portions
    func portionTooLarge(portionAmounts: NSMutableArray, total: Double){
        var x: Double = (total - 1)
        var i = 0
        for portion in portionAmounts{
            let p = portion as! Double
            let amount: Double = x / (Double(portionAmounts.count) - Double(i))
            if p - amount < 0{
                x = x - p
                portionAmounts[i] = 0
            } else{
                portionAmounts[i] = p - amount
                x = x - amount
            }
            i = i + 1
        }
        portionExtra(1 - getTotal(portionAmounts), portionAmounts: portionAmounts)
    }
    
    // Name: portionTooLargeZero
    // Param: portionAmounts: An array of the current portions for the user, total: The current total of all the portions added together, zeroPortions: A list of the indexes that contain 0 for their portion size
    // Return: None
    // Purpose: To portion when total > 1 and there are > 0 zero portions
    func portionTooLargeZero(portionAmounts: NSMutableArray, total: Double, zeroPortions: NSMutableArray){
        let amount: Double = (total - 1) / Double(portionAmounts.count - zeroPortions.count)
        for portion in zeroPortions{
            let p = portion as! Int
            portionAmounts[p] = amount
        }
        var i = 0
        for portion in portionAmounts{
            let p = portion as! Double
            portionAmounts[i] = p - amount
            i = i + 1
        }
        portionExtra(1 - getTotal(portionAmounts), portionAmounts: portionAmounts)
    }
    
    // Name: portionZero
    // Param: portionAmounts: An array of the current portions for the user, total: The current total of all the portions added together, zeroPortions: A list of the indexes that contain 0 for their portion size
    // Return: None
    // Purpose: To portion when total < 1 and there are no zero portions
    func portionZero(portionAmounts: NSMutableArray, zeroPortions: NSMutableArray, total: Double){
        let amount: Double = (1-total) / Double(zeroPortions.count)
        for portion in zeroPortions{
            let p = portion as! Int
            portionAmounts[p] = amount
        }
        portionExtra(1 - getTotal(portionAmounts), portionAmounts: portionAmounts)
    }
    
    // Name: getZeroPortionsTotal
    // Param: portionAmounts: An array of the current portions for the user
    // Return: A tuple containing the total of the portions and an array of all the portions containing zero
    // Purpose: To get the zero portions and total of the list
    func getZeroPortionsTotal(portionAmounts: NSMutableArray) -> (NSMutableArray, Double){
        let zeroPortions = NSMutableArray()
        var i = 0
        var total:Double = 0
        for portion in portionAmounts{
            let p = portion as! Double
            if p == 0{
                zeroPortions.addObject(i)
            } else{
                total = total + p
            }
            i = i + 1
        }
        return (zeroPortions, total)
    }
    
    // Name: deleteUserSubscribedPortion
    // Param: portions: An array of the current portions for the user, charityIndex: the index of the charity to update the portions for
    // Return: An array of updated portions
    // Purpose: TO delete a specific portion at an index and reportion
    func deleteSubscribedPortion(portions: NSMutableArray, charityIndex: Int) -> NSMutableArray{
        let last = portions[charityIndex] as! Double
        portions.removeObjectAtIndex(charityIndex)
        
        var count = 0
        for amount in portions{
            let a = amount as! Double
            let b = a + (last * a) + ((last * last) / Double(portions.count))
            portions[count] = b
            count += 1
        }
        
        return portions
    }
    
    // Name: addUserSubscribedPortions
    // Param: portionAmounts: An array of the current portions for the user
    // Return: An array of updated portions
    // Purpose: To add a specific portion and reportion
    func addSubscribedPortion(portions: NSMutableArray) -> NSMutableArray{
        var x = Double(0)
        var count = 0
        for amount in portions{
            let a = amount as! Double
            let b = a / Double(portions.count + 1)
            x += b
            portions[count] = a - b
            count += 1
        }
        portions.addObject(x)
        return portions
    }
    
    // Name: getTotal
    // Param: portions: An array of the current portions for the user
    // Return: The total of all portion amounts added together
    // Purpose: To get the total of the portions
    func getTotal(portions: NSMutableArray) -> Double{
        var total: Double = 0
        for portion in portions{
            let p = portion as! Double
            total = total + p
        }
        return total
    }
    
    // Name: portionExtra
    // Param: extra: The extra amount on top of the current portion amount, portionAmounts: An array of the current portions for the user
    // Return: None
    // Purpose: To portion any extra amount, usually due to recurring numbers
    func portionExtra(extra: Double, portionAmounts: NSMutableArray){
        portionAmounts[0] = Double(portionAmounts[0] as! NSNumber) + extra
    }
    
    // Name: checkEnabled
    // Param: portionAmounts: An array of the current portions for the user
    // Return: Boolean representing whether the back button should be enabled or not
    // Purpose: To check whether the back button should be enabled
    func checkEnabled(portionAmounts: NSMutableArray) -> Bool{
        // Check for back button enabled
        var total: Double = 0
        for portion in portionAmounts{
            let p:Double = portion as! Double
            if p == 0 {
                return true
            }
            total = total + p
        }
        if total == Double(1){
            return false
        }
        return true
    }
}
