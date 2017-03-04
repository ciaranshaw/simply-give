//
//  PaymentHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 30/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import Stripe

struct PaymentHandler {
    
    // Name: createBackendChargeWithToken
    // Param: token: The token which verifies the payment and card, uid: The userID of the user who is paying, amount: The monthly donation amount, user: The user object of the donater, completion: The function to be completed when the card is verified
    // Return: None
    // Purpose: To verify the card and the amount to be paid on it
    
    // TAKEN AND EDITED FROM THE STRIPE IOS API
    func createBackendChargeWithToken(token: STPToken, uid: String, amount: String, user: User, completion: PKPaymentAuthorizationStatus -> ()) {
        let url = NSURL(string: "http://:3000/token")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=\(token.tokenId)&userID=\(uid)&plan=\(amount)&email=\(user.userEmail!)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
            }
        }
        task.resume()
    }
    
    // Name: changePaymentDetails
    // Param: token: The updated STPToken to verify the amount the user has to pay, uid: The user ID of the user whose payment info is being updated, amount: The new monthly donation, duh: Database User Handler, ch: Core Data Handler
    // Return: None
    // Purpose: Update the user's payment details in the ch, duh and stripe system
    func changePaymentDetails(token: STPToken, uid: String, amount: String, duh: DatabaseUserHandler, ch: CoreDataHandler){
        duh.updatePaymentInformation(amount, userID: uid, ch: ch)
        
        let url = NSURL(string: "http://:3000/update_payment")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "userID=\(uid)&plan=\(amount)&stripeToken=\(token.tokenId)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request)
        task.resume()
    }
    
}