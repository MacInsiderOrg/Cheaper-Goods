//
//  Extensions.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 25.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func gradient(bounds: CGRect, color1: UIColor, color2: UIColor, color3: UIColor) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        var mainRect = bounds
        mainRect.size.width = 2000
        gradient.frame = mainRect
        gradient.colors = [color1.CGColor, color2.CGColor, color3.CGColor]
        return gradient
    }
}