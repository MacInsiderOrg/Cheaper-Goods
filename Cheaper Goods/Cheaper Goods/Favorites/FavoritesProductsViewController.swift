//
//  FavoritesProductsViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 17.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

struct Favorites {
    static var productObjects = [PFObject]()
    
    static func deleteProductAtIndex(productID: Int) {
        for (var i = 0; i < self.productObjects.count; i++) {
            let arrayProductID = self.productObjects[i]["productID"] as? Int
            
            if (arrayProductID == productID) {
                self.productObjects.removeAtIndex(i)
            }
        }
    }
}


class FavoritesProductsViewController: UITableViewController {
    
    var previousForm = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.previousForm == "Homepage") {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateProductsData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    /**
     * Update Products data
     */
    func updateProductsData() {

        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorites.productObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! FavortiesProductsCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if let object = Favorites.productObjects[indexPath.row] as PFObject! {
            
            if let productName = object["productName"] as? String {
                cell.productName.text = productName
            }
            
            if let productPrice = object["productPrice"] as? String {
                cell.productPrice.text = productPrice
            }
            
            if let productImage = object["productImage"] as? PFFile {
                Database.getImage(productImage, outImage: cell.productImage)
            }
            
            if let currentStoreID = object["storeID"] as? Int {
                Database.getImageByID("Store", currentID: currentStoreID, searchKey: "storeID", cellName: "storeImage", outImage: cell.storeImage)
            }
        }
        
        /* Set product name and price */
        //cell.productName.text = object["productName"] as? String
        //cell.productPrice.text = object["productPrice"] as? String
        
        /* Set product image */
        //let productImage = object["productImage"] as? PFFile
        //Database.getImage(productImage, outImage: cell.productImage)
        
        /* Set store image by Store ID */
        //let currentStoreID = object["storeID"] as! Int
        //Database.getImageByID("Store", currentID: currentStoreID, searchKey: "storeID", cellName: "storeImage", outImage: cell.storeImage)
        
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Favorites.productObjects.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openProductFromFavorites", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let productDetail: ArticleViewController = segue.destinationViewController as! ArticleViewController
        
        if segue.identifier == "openProductFromFavorites" {
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            if let object = Favorites.productObjects[indexPath.row] as PFObject! {
                productDetail.product = object
            }

            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}