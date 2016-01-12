//
//  Nav.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 25.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Foundation

class Nav : UINavigationController {
    
    @IBInspectable var blockSliding: Bool = false
    @IBInspectable var customTintColor = UIColor(netHex: 0x008C6A)
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        
        self.toolbar.barTintColor = self.customTintColor
        self.toolbar.tintColor = UIColor.whiteColor()
        
        //self.edgesForExtendedLayout = .All
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        let colorComponents = CGColorGetComponents(customTintColor.CGColor)
        let red = colorComponents[0]
        let green = colorComponents[1]
        let blue = colorComponents[2]
        let alpha = colorComponents[3]
        
        if red==0 && green==0 && blue==0 && alpha==0 {
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Compact)
            self.navigationBar.shadowImage = UIImage()
            //self.view.backgroundColor = UIColor.clearColor()
            self.navigationBar.backgroundColor = UIColor.clearColor()
        } else {
            self.navigationBar.barStyle = .Black
            self.navigationBar.barTintColor = self.customTintColor
        }

        self.navigationBar.translucent = true
        
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !self.blockSliding {
            self.view.addGestureRecognizer(self.slidingViewController().panGesture)
        }
    }
}