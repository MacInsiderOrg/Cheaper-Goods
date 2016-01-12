//
//  ProductsByCriteriaViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 19.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class ProductsByCriteriaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let items: [String]! = [NSLocalizedString("allProducts", comment: ""), NSLocalizedString("computerProducts", comment: ""), NSLocalizedString("tvProducts", comment: ""), NSLocalizedString("phoneProducts", comment: ""), NSLocalizedString("photoProducts", comment: ""), NSLocalizedString("techProducts", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CriteriaCell") as! CriteriaCell
        
        cell.criteriaName.text = items[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("menuChanged", object: indexPath.row)
        
        let indexPath = self.tableView.indexPathForSelectedRow!
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}