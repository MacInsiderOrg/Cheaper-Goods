//
//  StoreSalesViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 17.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class StoreSalesViewController: UITableViewController {
    
    var productObjects = NSMutableArray()
    var storeID = Int()
    var storeName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = self.storeName
        
        self.getProductsData()

        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateProductsData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    /**
     * Get all information about Product Objects, which contains in Current Store
     */
    func getProductsData() {
        
        var query: PFQuery = PFQuery(className: "Product")
        query.whereKey("storeID", equalTo: self.storeID)
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                
                let temp: NSArray = objects as AnyObject! as! NSArray
                self.productObjects = NSMutableArray(array: temp)
                
                self.tableView.reloadData()

            } else {
                println(error)
            }
        }
    }
    
    /**
     * Update Products data
     */
    func updateProductsData() {
        getProductsData()
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! StoreSalesCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        var object: PFObject = self.productObjects.objectAtIndex(indexPath.row) as! PFObject
        
        /* Set product name and price */
        cell.productName.text = object["productName"] as? String
        cell.productPrice.text = object["productPrice"] as? String
        
        /* Set product image */
        let productImage = object["productImage"] as? PFFile
        productImage!.getDataInBackgroundWithBlock {
            (imageData, error) -> Void in
            
            if (error == nil) {
                let image = UIImage(data: imageData!)
                cell.productImage.image = image
            }
        }
        
        /* Get and set store image */
        var currentStoreID = object["storeID"] as! Int
        var storeQuery: PFQuery = PFQuery(className: "Store")
        storeQuery.whereKey("storeID", equalTo: currentStoreID)
        storeQuery.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                for object in objects! {
                    
                    let storeImageFile = object["storeImage"] as? PFFile
                    storeImageFile?.getDataInBackgroundWithBlock {
                        (imageData, error) -> Void in
                        
                        if (error == nil) {
                            cell.storeImage.image = UIImage(data: imageData!)
                        }
                    }
                }
            }
        }
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("openProductFromStore", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if (segue.identifier == "openProductFromStore") {
            
            var productDetail: ArticleViewController = segue.destinationViewController as! ArticleViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            var object: PFObject = self.productObjects.objectAtIndex(indexPath.row) as! PFObject
            
            productDetail.product = object

            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}