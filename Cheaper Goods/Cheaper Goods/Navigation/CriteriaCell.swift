//
//  CriteriaCell.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 24.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class CriteriaCell: UITableViewCell {
    
    @IBOutlet weak var criteriaName: UILabel!
    
    override func awakeFromNib() {
        criteriaName.font = UIFont(name: "Helvetica-Neue", size: 16)
        criteriaName.backgroundColor = UIColor.clearColor()
    }
}

