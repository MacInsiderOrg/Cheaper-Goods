//
//  StoreViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class StoreViewController: UITableViewController {
    
    var previousForm = String()
    var storeObjects = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.previousForm == "Homepage") {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }

        self.getStoresData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateStoresData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    /**
     * Get all information about Store objects
     */
    func getStoresData() {
        Database.getObjects("Store", objects: &storeObjects, tableView: &self.tableView, orderBy: true)
    }

    /**
     * Update Stores data
     */
    func updateStoresData() {
        self.getStoresData()
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCellWithIdentifier("StorePreview", forIndexPath: indexPath) as! StorePreviewCell
        
        let object: PFObject = self.storeObjects.objectAtIndex(indexPath.row) as! PFObject
        
        cell.storeLabel?.text = object["storeName"] as? String

        let storeImage = object["storeImage"] as? PFFile
        Database.getImage(storeImage, outImage: cell.storeImage)

        return cell
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openStoreSales", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let StoreProducts: ViewController = segue.destinationViewController as! ViewController

        if segue.identifier == "openStoreSales" {
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let object: PFObject = self.storeObjects.objectAtIndex(indexPath.row) as! PFObject

            StoreData.storeID = object["storeID"] as? Int
            StoreData.storeName = object["storeName"] as? String
            StoreProducts.previousForm = "Store"
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}