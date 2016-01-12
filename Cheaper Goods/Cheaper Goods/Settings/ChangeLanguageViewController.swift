//
//  ChangeLanguageViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UITableViewController {
    
    var languageID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: self.languageID, inSection: 0), animated: false)
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.languageID, inSection: 0))
        cell?.accessoryType = UITableViewCellAccessoryType.None
        
        self.tableView.reloadData()
        
        self.languageID = Preferences.currentLanguageID

        let newCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.languageID, inSection: 0))
        newCell?.accessoryType = UITableViewCellAccessoryType.Checkmark

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row != self.languageID) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)

            if cell != nil {
                // Set the CellID
                
                var label:UILabel = UILabel()
                for subview in self.view.subviews {
                    if subview is UILabel {
                        label = subview as! UILabel
                        break
                    }
                }
                
                var cellID: AnyObject! = (label.text == nil) ? "" : label.text
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                var previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.languageID, inSection: 0))
                previousCell?.accessoryType = UITableViewCellAccessoryType.None
            }

            self.languageID = indexPath.row
            Preferences.currentLanguageID = indexPath.row
        }
        
        var VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("preferencesHome") as! PreferencesViewController
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
}
