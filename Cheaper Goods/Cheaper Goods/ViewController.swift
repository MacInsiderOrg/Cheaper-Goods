//
//  ViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

/* Contain data about current product Store */
struct StoreData {
    static var storeID: Int?                // Store Number
    static var storeName: String?           // Store Name
}

class ViewController: UITableViewController {
    
    var previousForm = String()             // Contain label of form, from which the transition was made
    var productObjects = NSMutableArray()   // Contain all products
    
    /* Criteria data */
    var categoryID = Int()
    var menu: ProductsByCriteriaViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let m = self.storyboard?.instantiateViewControllerWithIdentifier("ProductsByCriteriaViewController") as? ProductsByCriteriaViewController {
            m.edgesForExtendedLayout     = [.Top, .Bottom, .Right]
            menu = m
        }
        
        switch self.previousForm {
            case "Store":
                title = StoreData.storeName
                self.navigationItem.setLeftBarButtonItem(nil, animated: true)

            case "SalesByCriteria":
                break
            
            case "Homepage":
                self.navigationItem.setLeftBarButtonItem(nil, animated: true)
                
            default:
                StoreData.storeID = nil
                StoreData.storeName = nil
        }

        self.getProductsData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateProductsData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuChanged:", name: "menuChanged", object: nil)
    }
    
    /**
     * Get all information about Product Objects
     */
    func getProductsData() {
        
        let query: PFQuery = PFQuery(className: "Product")
        query.orderByAscending("productID")
        
        if (self.previousForm == "Store") {
            query.whereKey("storeID", equalTo: StoreData.storeID!)
            
        } else if (self.previousForm == "SalesByCriteria") {
            
            if (self.categoryID != 0) {
                query.whereKey("categoryID", equalTo: self.categoryID)
            }
            
            if (StoreData.storeID != nil) {
                query.whereKey("storeID", equalTo: StoreData.storeID!)
            }
        }
        
        Database.retrieveObjects(query, objects: &self.productObjects, tableView: &self.tableView)
    }
    
    /**
     * Update Products data
     */
    func updateProductsData() {
        self.getProductsData()
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.slidingViewController().underRightViewController = menu
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.slidingViewController().underRightViewController = nil
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func menuChanged(notif: NSNotification) {
        categoryID = notif.object as! Int
        previousForm = "SalesByCriteria"
        self.updateProductsData()
        self.slidingViewController().resetTopViewAnimated(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! TimelineCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        let object: PFObject = self.productObjects.objectAtIndex(indexPath.row) as! PFObject
        
        /* Set product name and price */
        cell.productName.text = object["productName"] as? String
        cell.productPrice.text = object["productPrice"] as? String
        
        cell.productImage.image = nil
        /* Set product image */
        let productImage = object["productImage"] as? PFFile
        Database.getImage(productImage, outImage: cell.productImage)
        
        cell.storeImage.image = nil
        /* Set store image by store ID */
        let currentStoreID = object["storeID"] as! Int
        Database.getImageByID("Store", currentID: currentStoreID, searchKey: "storeID", cellName: "storeImage", outImage: cell.storeImage)

        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openProduct", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openProduct" {
            
            let productDetail: ArticleViewController = segue.destinationViewController as! ArticleViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let object: PFObject = self.productObjects.objectAtIndex(indexPath.row) as! PFObject
            
            productDetail.product = object
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}