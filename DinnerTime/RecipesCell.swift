//
//  RecipesCell.swift
//  DinnerTime
//
//  Created by Caroline Davis on 15/11/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import UIKit


class RecipesCell: UITableViewCell {
    
    var viewBtn: UIButton!
    var recipeLbl: UILabel!
    var heart: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeLbl = UILabel(frame: CGRect(x: 10, y: 10, width: 225, height: 21))
        recipeLbl.font = UIFont(name: "Helvetica Neue", size: 14)
        
        // setting the view button up
        viewBtn = UIButton(frame: CGRect(x: 249, y: 11, width: 55, height: 24))
        viewBtn.backgroundColor = UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0)
        viewBtn.setTitle("VIEW", for: .normal)
        viewBtn.setTitleColor(.white, for: .normal)
        viewBtn.setTitleColor(UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0), for: .highlighted)
        viewBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        viewBtn.layer.cornerRadius = 10
        
        heart = UIButton(frame: CGRect(x: 305, y: 5, width: 38, height: 36))
        heart.setTitle("♥︎", for: .normal)
        heart.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 34)
        
        addSubview(recipeLbl)
        addSubview(viewBtn)
        addSubview(heart)
        
        
    }
    
    
    
}



