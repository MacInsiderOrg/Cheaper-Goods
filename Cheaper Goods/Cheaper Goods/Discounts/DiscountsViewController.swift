//
//  DiscountsViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 25.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class DiscountsViewController: UITableViewController {
    
    var discountObjects = NSMutableArray()
    var previousForm = String()
    var storeData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.previousForm == "Homepage") {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
        
        self.getDiscountsData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateProductsData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    /**
     * Get discounts data
     */
    func getDiscountsData() {
        Database.getObjects("Discounts", objects: &self.discountObjects, tableView: &self.tableView, orderBy: true)
    }
    
    /**
     * Update Discounts data
     */
    func updateProductsData() {
        self.getDiscountsData()
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discountObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DiscountCell", forIndexPath: indexPath) as! DiscountCell
        
        let object: PFObject = self.discountObjects.objectAtIndex(indexPath.row) as! PFObject

        cell.discountTime.text = object["discountTime"] as? String
        
        cell.discountImage.image = nil

        /* Set discount image */
        let discountImage = object["discountImage"] as? PFFile
        Database.getImage(discountImage, outImage: cell.discountImage)
        
        if (object["dateColor"] as? String == "black") {
            cell.dateImage.image = UIImage(named: "clock")
            cell.discountTime.textColor = UIColor.darkGrayColor()
        } else {
            cell.dateImage.image = UIImage(named: "clock_white")
            cell.discountTime.textColor = UIColor.whiteColor()
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openDetail" {
            
            let openDiscount: DiscountViewController = segue.destinationViewController as! DiscountViewController
            let indexPath = self.tableView.indexPathForSelectedRow!

            let object: PFObject = self.discountObjects.objectAtIndex(indexPath.row) as! PFObject
            openDiscount.discount = object

            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
