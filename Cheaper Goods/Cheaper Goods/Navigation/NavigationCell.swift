//
//  NavigationCell.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class NavigationCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        titleLabel.font = UIFont(name: "Helvetica-Neue", size: 16)
        titleLabel.backgroundColor = UIColor.clearColor()
    }
}
