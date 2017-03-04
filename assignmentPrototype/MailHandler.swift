//
//  MailHandler.swift
//  assignmentPrototype
//
//  Created by Ciaran Shaw on 7/06/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import Foundation
import MessageUI

struct MailHandler{
    
    // Name: configuredMailComposeViewController
    // Param: context: A View controller that has the MFMailComposeViewController Delegate, subject: The subject of the email
    // Return: A view controller for the mail screen
    // Purpose: To create a view for the user to send an email
    func configuredMailComposeViewController<T: UIViewController where T: MFMailComposeViewControllerDelegate>(context: T, subject: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = context
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject(subject)
        
        return mailComposerVC
    }
    
    // Name: sendPDFMail
    // Param: userID: The userID of the user to send the email to
    // Return: None
    // Purpose: To send a pdf document containing all the user information to the user
    func sendPDFMail(userID: String){
        let url = NSURL()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        let body = "userID=\(userID)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request)
        task.resume()
    }
}
