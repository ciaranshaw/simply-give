//
//  RegisterSecondViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit

class RegisterSecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    var task: String?
        
    @IBOutlet weak var imgProfilePicture: UIImageView!
    
    let imagePicker = UIImagePickerController()
        
    @IBAction func selectPicture(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Photo", message: "Select Option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Select From Library", style: UIAlertActionStyle.Default, handler: getPhotoFromLibrary))
        alertController.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: getPhotoFromCamera))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imgProfilePicture.layer.borderWidth = 1
        imgProfilePicture.layer.masksToBounds = true
        imgProfilePicture.layer.borderColor = UIColor.blackColor().CGColor
        imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.height/2
        imgProfilePicture.clipsToBounds = true
        
        if(self.task == "Edit"){
            imgProfilePicture.image = UIImage(data:(user?.userProfilePicture)!)
        }
    }
    
    func getPhotoFromCamera(action: UIAlertAction){
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
            presentViewController(imagePicker, animated: true, completion: nil)
        } else{
            noCamera()
        }
    }
    
    
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func getPhotoFromLibrary(action: UIAlertAction!){
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        user?.userProfilePicture = UIImageJPEGRepresentation(chosenImage, 1.0)
        imgProfilePicture.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DevelopUserSegueTwo"{
            let controller = segue.destinationViewController as! RegisterThirdViewController
            controller.user = user
            
            if self.task == "Edit"{
                controller.task = "Edit"
            }
        }

    }
    
    

}
