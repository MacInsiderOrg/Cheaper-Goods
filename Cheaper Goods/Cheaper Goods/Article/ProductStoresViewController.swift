//
//  ProductStoresViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 26.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class ProductStoreList: UITableViewCell {
    
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
}

class ProductStoresViewController: UIViewController {
    
    var store: PFObject!            // Current Store
    var stores = NSMutableArray()   // Store Affilience

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tblView =  UIView(frame: CGRectZero)
        self.mainTable.tableFooterView = tblView
        self.mainTable.tableFooterView!.hidden = true
        self.mainTable.backgroundColor = UIColor.clearColor()
        
        /* Set store image */
        let storeImage = self.store["storeImage"] as? PFFile
        Database.getImage(storeImage, outImage: self.storeImage)
        
        /* Set store name */
        self.storeName.text = self.store["storeName"] as? String

        self.mainTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.mainTable.dequeueReusableCellWithIdentifier("ProductStoreList") as! ProductStoreList
        let object: PFObject = self.stores.objectAtIndex(indexPath.row) as! PFObject

        cell.storeTitle.text = object["storeName"] as? String
        cell.storeAddress.text = object["storeAddress"] as? String

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openDetail" {
            
            let productStore: MapViewController = segue.destinationViewController as! MapViewController
            
            let indexPath = self.mainTable.indexPathForSelectedRow!
            let object: PFObject = self.stores.objectAtIndex(indexPath.row) as! PFObject
            
            productStore.store = object
            productStore.storeTitle = self.store["storeName"] as! String

            /* Get store image */
            let storeImage = self.store["storeImage"] as? PFFile
            storeImage!.getDataInBackgroundWithBlock {
                (imageData, error) -> Void in
                
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    productStore.imageView.image = image
                }
            }
            
            self.mainTable.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}