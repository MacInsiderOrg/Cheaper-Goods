//
//  ArticleViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class ArticleViewController: UITableViewController {
    
    var product: PFObject!              // Current Product
    var imagesArray: [UIImage] = []     // Product Images
    var storeData = NSMutableArray()    // All Store Data
    var storesData = NSMutableArray()   // Contain all data about product affiliates
    
    @IBOutlet weak var starIcon: UIBarButtonItem!
    
    /**
     * Performs actions when the user presses a star
     */
    @IBAction func act(sender: AnyObject) {
        
        let currentID = self.product["productID"] as? Int
        
        Database.addDiscountToFavorite("Product", currentID: currentID, searchKey: "productID", starIcon: self.starIcon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.product != nil) {
            title = self.product["productName"] as? String
            
            if Favorites.productObjects.contains(self.product) {
                self.starIcon.image = UIImage(named: "icons_star_hover")
            } else {
                self.starIcon.image = UIImage(named: "icons_star")
            }

            /**
             * Get product images and save into UIImage array
             */
            let currentImagesID = self.product["productImagesID"] as? Int
            let imagesQuery: PFQuery = PFQuery(className: "Images")
            imagesQuery.whereKey("productImagesID", equalTo: currentImagesID!)
            
            imagesQuery.findObjectsInBackgroundWithBlock {
                (images, error) -> Void in
                
                if (error == nil) {
                    
                    for image in images! {
                        let imageFile = image["imageFile"] as? PFFile
                        
                        imageFile?.getDataInBackgroundWithBlock {
                            (imageData, error) -> Void in
                            
                            if (error == nil) {
                                let uiimage = UIImage(data: imageData!)
                                self.imagesArray.append(uiimage!)
                            }
                        }
                    }
                }
            }
            
            /**
             * Get product data about store and his location, etc.
             */
            
            let currentStoreID = self.product["storeID"] as? Int
            var storeQuery: PFQuery = PFQuery(className: "Store")
            storeQuery.whereKey("storeID", equalTo: currentStoreID!)
            
            storeQuery.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                
                if (error == nil) {
                    let temp: NSArray = objects as AnyObject! as! NSArray
                    self.storeData = NSMutableArray(array: temp)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.toolbarHidden = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! ArticleHeaderCell
            
            /* Set product cover image */
            let productImage = self.product["productImage"] as? PFFile
            Database.getImage(productImage, outImage: cell.productImage)

            /* Set product price */
            cell.priceLabel.text = self.product["productPrice"] as? String

            return cell

        } else if indexPath.row == 1 {

            let cell = tableView.dequeueReusableCellWithIdentifier("Description") as! ArticleDescriptionCell

            /* Set product description */
            cell.descriptionText.text = self.product["productDesc"] as? String

            return cell

        } else if indexPath.row == 2 {

            let cell = tableView.dequeueReusableCellWithIdentifier("Characteristics") as! ArticleTechSpecsCell

            /* Set product tech specification */
            cell.techSpecsText.text = self.product["productSpec"] as? String

            return cell
        }

        return UITableViewCell()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "openImages" {

            let productImages: ImagesViewController = segue.destinationViewController as! ImagesViewController

            for (var i = 0; i < self.imagesArray.count; i++) {
                productImages.pageImages.append(self.imagesArray[i])
            }

        } else if segue.identifier == "openStores" {
            
            let productStores: ProductStoresViewController = segue.destinationViewController as! ProductStoresViewController
            let object: PFObject = self.storeData.objectAtIndex(0) as! PFObject

            productStores.store = object
            productStores.stores = self.storesData
        }
    }
}

class ArticleHeaderCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
}

class ArticleDescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionText: UILabel!
}

class ArticleTechSpecsCell: UITableViewCell {
    @IBOutlet weak var techSpecsText: UILabel!
}
