//
//  UserProfileSubscribedViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 9/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class UserProfileSubscribedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var user: User?
    var userCharities = NSMutableArray()
    
    var footer: FooterCollectionViewCell?
    
    let ch = CoreDataHandler()
    let dch = DatabaseCharityHandler()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        userCharities = NSMutableArray()
        collectionView.reloadData()
        if(footer == nil){
            footer = collectionView.subviews[2] as? FooterCollectionViewCell
        }
        footer?.hidden = false
        footer?.activityIndicator!.hidden = false
        footer?.activityIndicator.startAnimating()
        getUserCharities()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return userCharities.count
    }
    // To load the cells of the charities needed
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("charityCell", forIndexPath: indexPath) as! CharityCollectionViewCell
                
        // Configure the cell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let charity = userCharities[indexPath.item] as! Charity
        
        cell.lblCharityName.text = charity.charityName
        cell.lblCharityDescription.text = charity.charityDesc
        cell.imgCharityLogo.image = UIImage(data: charity.charityLogo!)
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            return headerView
        } else{
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            return footer
        }
    }
    
    func collectionView(collection collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSizeMake(0,50)
    }
    
    func collectionView(collection collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSizeMake(0,50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("CharityProfileView") as! CharityProfileViewController
        
        controller.charity = userCharities[indexPath.row] as? Charity
        self.navigationController?.pushViewController(controller, animated: true)
    
    }
    
    // Function to get the user charities by getting the list of charity ids from the user data, and using the dch function to get all charities
    func getUserCharities(){
        let userData = ch.getUserData()
        if userData.userSubscribed!.count == 0{
            self.userCharities = NSMutableArray()
            self.collectionView.reloadData()
            footer?.activityIndicator.hidden = true
            footer?.lblNoCharities.hidden = false
            footer?.activityIndicator.stopAnimating()
        } else{
            footer?.lblNoCharities.hidden = true
            dch.getCharitiesFromIDList(userData.userSubscribed!, next: { charities in
                self.userCharities = charities
                self.collectionView.reloadData()
                self.footer!.hidden = true
            })
            
        }
    }
}
