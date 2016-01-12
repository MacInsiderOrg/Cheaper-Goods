//
//  MenuViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class NavigationModel {
    
    var title: String!
    var icon: String!
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [NavigationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None

        let item1 = NavigationModel(title: NSLocalizedString("Home", comment: ""), icon: "icon_home")
        let item2 = NavigationModel(title: NSLocalizedString("Sales", comment: ""), icon: "icon_sales")
        let item3 = NavigationModel(title: NSLocalizedString("Stock", comment: ""), icon: "icon_stock")
        let item4 = NavigationModel(title: NSLocalizedString("Stores", comment: ""), icon: "icon_store")
        let item5 = NavigationModel(title: NSLocalizedString("Favorites", comment: ""), icon: "icon_favorite")

        items = [item1, item2, item3, item4, item5]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as! NavigationCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.iconView.image = UIImage(named: item.icon)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
            case 0:
                self.slidingViewController().setTopViewControllerWithStoryboardID("preview")
            case 1:
                self.slidingViewController().setTopViewControllerWithStoryboardID("main")
            case 2:
                self.slidingViewController().setTopViewControllerWithStoryboardID("discounts")
            case 3:
                self.slidingViewController().setTopViewControllerWithStoryboardID("manufacturers")
            case 4:
                self.slidingViewController().setTopViewControllerWithStoryboardID("favorites")
            default:
                self.slidingViewController().setTopViewControllerWithStoryboardID("preview")
        }
        
        self.slidingViewController().resetTopViewAnimated(true)
    }
    
    @IBAction func openTwitter(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://twitter.com/TheBestMacApps")!)
    }

    @IBAction func openFacebook(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.facebook.com/MacInsider.org")!)
    }
    
    @IBAction func openVK(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://vk.com/macinsider")!)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
