//
//  MenuItem.swift
//  DinnerTime
//
//  Created by Caroline Davis on 26/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class MenuItem: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // shadowing
        layer.shadowColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
    }
    
}
