//
//  Cell.swift
//  DinnerTime
//
//  Created by Caroline Davis on 31/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import UIKit

func setTheCells(recipeLabel: UILabel, viewButton: UIButton) {
    
    recipeLabel.font = UIFont(name: "Helvetica Neue", size: 14)
    
    // setting the view button up
    viewButton.backgroundColor = UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0)
    viewButton.setTitle("VIEW", for: .normal)
    viewButton.setTitleColor(.white, for: .normal)
    viewButton.setTitleColor(UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0), for: .highlighted)
    viewButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
    viewButton.layer.cornerRadius = 10
    
    
    
}
