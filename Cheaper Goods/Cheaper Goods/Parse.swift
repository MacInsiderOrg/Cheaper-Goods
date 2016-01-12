//
//  Parse.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 19.06.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit

class Database {
    

    /**
     * Order By Table (ASC, DESC)
     */
    static func orderBy(query: PFQuery, table: String) {
        
        switch table {
            case "Discounts":
                query.orderByAscending("discountID")
            
            case "Store":
                query.orderByAscending("storeID")
            
            default:
                break
        }
        
    }
    
    /**
     * Get Objects
     */
    static func getObjects(className: String, inout objects: NSMutableArray, inout tableView: UITableView!, orderBy: Bool) {
        
        let query: PFQuery = PFQuery(className: className)
        
        if orderBy {
            Database.orderBy(query, table: className)
        }
        
        objects = NSMutableArray()
        
        query.findObjectsInBackgroundWithBlock {
            (data, error) -> Void in
            
            if error == nil {
                
                for object in data as AnyObject! as! NSArray {
                    objects.addObject(object)
                }
                
                tableView.reloadData()
                
            } else {
                print(error)
            }
        }
    }
    

    /**
     *
     */
    static func retrieveObjects(query: PFQuery, inout objects: NSMutableArray, inout tableView: UITableView!) {

        objects = NSMutableArray()
        
        query.findObjectsInBackgroundWithBlock {
            (data, error) -> Void in
            
            if error == nil {
                
                for object in data as AnyObject! as! NSArray {
                    objects.addObject(object)
                }
                
                tableView.reloadData()
                
            } else {
                print(error)
            }
        }
    }
    
    /**
     * Get Image and set into UIImageView
     */
    static func getImage(imageQuery: PFFile!, outImage: UIImageView!) {

        imageQuery.getDataInBackgroundWithBlock {
            (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    outImage?.image = UIImage(data: imageData)
                }
            }
        }

    }
    
    /**
     * Get Image and set into UIImage
     *
    static func getImage(imageQuery: PFFile!, var image: UIImage) {
        
        imageQuery!.getDataInBackgroundWithBlock {
            (imageData, error) -> Void in
            if (error == nil) {
                image = UIImage(data: imageData!)!
            }

        }
        
    }*/
    
    /**
     * Get image by ID
     */
    static func getImageByID(className: String, currentID: Int, searchKey: String, cellName: String, outImage: UIImageView?) {

        let query: PFQuery = PFQuery(className: className)

        query.whereKey(searchKey, equalTo: currentID)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                for object in objects! {
                    
                    let imageFile = object[cellName] as? PFFile
                    Database.getImage(imageFile, outImage: outImage)
                    
                }
            }
        }

    }
    
    
    /**
     * Add discount to Favorite list
     */
    static func addDiscountToFavorite(className: String, currentID: Int!, searchKey: String, starIcon: UIBarButtonItem!) {

        let query: PFQuery = PFQuery(className: className)
        query.whereKey(searchKey, equalTo: currentID)
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                for object in objects! {
                    
                    if Favorites.productObjects.contains(object) {
                        Favorites.deleteProductAtIndex((object[searchKey] as? Int)!)
                        starIcon.image = UIImage(named: "icons_star")
                    } else {
                        Favorites.productObjects.append(object)
                        starIcon.image = UIImage(named: "icons_star_hover")
                    }
                }
            }
        }

    }
    
    
    /**
     * Send user review
     */
    static func sendAppReview(className: String, nameField: UITextField, textField: UITextField) {
        
        let lastReview: PFQuery = PFQuery(className: className)
        var lastReviewID = 0
        
        lastReview.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                
                let temp: NSArray = objects as AnyObject! as! NSArray
                let obj = NSMutableArray(array: temp)
                
                if (obj.count != 0) {
                    lastReviewID = obj.count
                }
                
                let userReview = PFObject(className: "Feedback")
                
                userReview["feedbackID"] = ++lastReviewID
                userReview["userName"] = nameField.text
                userReview["userReview"] = textField.text
                
                userReview.saveInBackgroundWithBlock {
                    (success, error) -> Void in
                    
                    if (success) {
                        print("Success, message was send")
                    } else {
                        print(error)
                    }
                }

            } else {
                print(error)
            }
        }
    }
    
    
}
