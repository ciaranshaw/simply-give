//
//  LoadingViewController.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 2/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let duh = DatabaseUserHandler()
    let ph = PaymentHandler()
    let ch = CoreDataHandler()
    
    var command: String?
    var user: User?
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }

}
