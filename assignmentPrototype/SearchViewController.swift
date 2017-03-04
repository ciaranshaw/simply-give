//
//  SearchViewController.swift
//  finalAssignmentPrototype
//
//  Created by Ciaran Shaw on 2/05/2016.
//  Copyright © 2016 Ciaran Shaw. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var searchedCharities = NSMutableArray()
    var allCharities = NSMutableArray()
    var managedObjectContext: NSManagedObjectContext?
    let dch = DatabaseCharityHandler()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    // When the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self

        self.conformView("Search")
        
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Performed when the user clicks search
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchedCharities = NSMutableArray()
        collectionView.reloadData()
        self.searchBar.endEditing(true)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let footer = self.collectionView!.subviews[2] as? FooterCollectionViewCell
        print(collectionView.subviews)
        footer?.activityIndicator.startAnimating()
        footer?.activityIndicator.hidden = false
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dch.searchCharities(searchBar.text!, allCharities: allCharities, next: {searchResults in
            self.searchedCharities = searchResults
            self.collectionView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            footer?.activityIndicator.stopAnimating()
        })
    }
    
    // To be executed when the view is loaded
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    // Returns the number of items in the collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return searchedCharities.count
    }
    
    // Establishes views for header and footer
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            return headerView
        } else{
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            return footer
        }

    }
    
    // Draws header view
    func collectionView(collection collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize{
            return CGSizeMake(0,50)
    }
    
    // Draws footer view
    func collectionView(collection collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSizeMake(0,50)
    }
    
    // Code to create charity cell from list of charities searched
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("charityCell", forIndexPath: indexPath) as! CharityCollectionViewCell
        
        // Configure the cell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        let charity = searchedCharities[indexPath.item] as! Charity
        
        cell.lblCharityName.text = charity.charityName
        cell.lblCharityDescription.text = charity.charityDesc
        cell.imgCharityLogo.image = UIImage(data: charity.charityLogo!)
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    // When the user clicks on a charity from the view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewCharitySegue"{
            let sentCharity = searchedCharities[self.collectionView.indexPathsForSelectedItems()![0].row] as! Charity
            let controller = segue.destinationViewController as! CharityProfileViewController
            controller.charity = sentCharity
        }
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

