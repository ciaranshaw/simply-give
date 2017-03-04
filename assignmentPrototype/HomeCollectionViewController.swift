///Users/ciaranshaw/Documents/Google Drive/FIT3027/finalAssignmentPrototype/finalAssignmentPrototype/SearchViewController.swift
//  HomeCollectionViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 3/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class HomeCollectionViewController: UICollectionViewController{
    
    var allCharities: NSMutableArray
    let reuseIdentifier = "charityCell"
    var cellsLoaded: Int
    var charitiesLoaded: Bool
    let dch = DatabaseCharityHandler()
    
    var managedObjectContext: NSManagedObjectContext?
    
    // Performed when the app is loaded
    required init?(coder aDecoder: NSCoder) {
        self.cellsLoaded = 0
        self.charitiesLoaded = false
        self.allCharities = NSMutableArray()
        super.init(coder: aDecoder)
        // Set up the tab bar item for home page
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home-32"), selectedImage: UIImage(named: "home_filled-32"))
    }

    // When the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conformView("Home")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        // Do any additional setup after loading the view.

        getCharities()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.allCharities.count
    }

    // Creates a cell for each item in the list of charities
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CharityCollectionViewCell
    
        // Configure the cell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let charity: Charity = self.allCharities[indexPath.row] as! Charity
        
        cell.lblCharityName.text = charity.charityName
        cell.lblCharityDescription.text = charity.charityDesc
        
        cell.imgCharityLogo.image = UIImage(data: charity.charityLogo!)
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    // Initiates the footer and the header
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            return headerView
        } else{
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            return footer
        }
    }
    
    // Sets the size for the header
    func collectionView(collection collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize{
            return CGSizeMake(0,50)
    }
    
    // Sets the size for the footer
    func collectionView(collection collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize{
            return CGSizeMake(0,50)
    }
    
    // Indicates to start loading the next charity blocks
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == self.cellsLoaded - 1{
            if(self.charitiesLoaded){
                return
            } else {
                let footer = collectionView.subviews[8] as? FooterCollectionViewCell
                footer?.activityIndicator.startAnimating()
                getCharities()
            }
        }
    }
    
    // Perfoormed when the user wants to view a charity
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewCharitySegue"{
            let charity = allCharities[(self.collectionView?.indexPathsForSelectedItems()?[0].row)!] as? Charity
            let controller: CharityProfileViewController = segue.destinationViewController as! CharityProfileViewController
            controller.charity = charity
        }
    }
    
    // Get an amount of charities and load them into the current collection view
    func getCharities(){
        
        //Function to get actual charities stored
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dch.getCharitiesInBlocks(self.cellsLoaded, blockSize: 5, next: {charities in
            if(charities.count == 0){
                let footer = self.collectionView!.subviews[9] as? FooterCollectionViewCell
                footer!.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            self.cellsLoaded += charities.count
            self.allCharities.addObjectsFromArray(charities as [AnyObject])
            self.collectionView?.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let footer = self.collectionView!.subviews[3] as? FooterCollectionViewCell
            footer?.activityIndicator.stopAnimating()
        })
    }
}