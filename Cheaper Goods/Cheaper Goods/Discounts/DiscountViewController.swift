//
//  DiscountViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 25.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class DiscountHeaderCell: UITableViewCell {
    @IBOutlet weak var discountImage: UIImageView?
    @IBOutlet weak var discountName: UILabel?
    @IBOutlet weak var dateImage: UIImageView?
    @IBOutlet weak var discountTime: UILabel?
}

class DiscountDescCell: UITableViewCell {
    @IBOutlet weak var discountDesc: UILabel?
}

class DiscountStoreCell: UITableViewCell {
    @IBOutlet weak var discountStore: UILabel?
    @IBOutlet weak var storeImage: UIImageView?
}

class DiscountViewController: UITableViewController {
    
    var discount: PFObject!
    var storeData = NSMutableArray()
    var storesData = NSMutableArray()
    var storeLabel = String()
    var strImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.discount != nil) {
            //title = self.discount["discountName"] as? String
            
            /**
             * Get product data about store and his location, etc.
             */
            let currentStoreID = self.discount["storeID"] as? Int
            var storeQuery: PFQuery = PFQuery(className: "Store")
            storeQuery.whereKey("storeID", equalTo: currentStoreID!)
            
            storeQuery.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                
                if (error == nil) {
                    
                    let temp: NSArray = objects as AnyObject! as! NSArray
                    self.storeData = NSMutableArray(array: temp)
                    
                    self.tableView.reloadData()
                    
                    let object: PFObject = self.storeData.objectAtIndex(0) as! PFObject
                    
                    self.storeLabel = (object["storeName"] as? String)!
                    
                    /* Set store image */
                    let storeImage = object["storeImage"] as? PFFile

                    storeImage!.getDataInBackgroundWithBlock {
                        (imageData, error) -> Void in
                        
                        if (error == nil) {
                            let image = UIImage(data: imageData!)
                            self.strImage = image!
                        
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            storeQuery = PFQuery(className: "Stores")
            storeQuery.whereKey("storeID", equalTo: currentStoreID!)
            
            storeQuery.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                
                if (error == nil) {
                    let temp: NSArray = objects as AnyObject! as! NSArray
                    self.storesData = NSMutableArray(array: temp)
                }
            }
        }

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! DiscountHeaderCell

            /* Get product cover image */
            let discountImage = self.discount["discountImage"] as? PFFile
            Database.getImage(discountImage, outImage: cell.discountImage)

            cell.discountName!.text = self.discount["discountName"] as? String
            cell.discountTime!.text = self.discount["discountTime"] as? String
            
            if (self.discount["dateColor"] as? String == "black") {
                cell.dateImage!.image = UIImage(named: "clock")
                cell.discountTime!.textColor = UIColor.darkGrayColor()
            } else {
                cell.dateImage!.image = UIImage(named: "clock_white")
                cell.discountTime!.textColor = UIColor.whiteColor()
            }
            
            return cell

        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("StoreCell") as! DiscountStoreCell

            cell.storeImage!.image = self.strImage
            cell.discountStore!.text = self.storeLabel

            return cell
            
        } else if indexPath.row == 2 {
           
            let cell = tableView.dequeueReusableCellWithIdentifier("Description") as! DiscountDescCell
            
            cell.discountDesc!.text = self.discount["discountDesc"] as? String
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "openSalesStores" {
            if let destination = segue.destinationViewController as? ProductStoresViewController {
                
                let object: PFObject = self.storeData.objectAtIndex(0) as! PFObject

                destination.store = object
                destination.stores = self.storesData
                
                let indexPath = self.tableView.indexPathForSelectedRow!
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
}