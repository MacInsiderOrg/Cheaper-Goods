//
//  AllProductsCell.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 16.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class AllProductsCell: UITableViewCell {
 
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.storeImage.layer.cornerRadius = self.storeImage.frame.size.width / 2;
        self.storeImage.clipsToBounds = true;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}