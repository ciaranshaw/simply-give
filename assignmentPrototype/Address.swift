//
//  Address.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 4/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation

class Address: NSObject{
    
    var userStreetNumber: Int?
    var userStreetName: String?
    var userCity: String?
    var userPostcode: String?
    var userState: String?
    
    init(userStreetNumber: Int, userStreetName: String, userCity: String, userPostcode: String, userState: String){
        
        self.userStreetNumber = userStreetNumber
        self.userStreetName = userStreetName
        self.userCity = userCity
        self.userPostcode = userPostcode
        self.userState = userState
    }
    
    override init(){
        self.userStreetNumber = 0
        self.userStreetName = ""
        self.userCity = ""
        self.userPostcode = ""
        self.userState = ""
    }
    
    func toString() -> String{
        let num = userStreetNumber!
        return "\(String(num)) \(userStreetName!)\n\(userCity!) \(userPostcode!)\n\(userState!) Australia"
    }
    
    
}
