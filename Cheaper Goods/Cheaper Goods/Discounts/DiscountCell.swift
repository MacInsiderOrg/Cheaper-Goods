//
//  DiscountCell.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 25.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {
    
    @IBOutlet weak var discountImage: UIImageView!
    @IBOutlet weak var discountTime: UILabel!
    @IBOutlet weak var dateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}