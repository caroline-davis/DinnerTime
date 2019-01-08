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
        
        recipeLbl = UILabel(frame: CGRect(x: 10, y: 10, width: 190, height: 21))
        recipeLbl.font = UIFont(name: "Helvetica Neue", size: 12)
        
        // setting the view button up
        viewBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 24))
        viewBtn.backgroundColor = UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0)
        viewBtn.setTitle(" VIEW ", for: .normal)
        viewBtn.setTitleColor(.white, for: .normal)
        viewBtn.setTitleColor(UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0), for: .highlighted)
        viewBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        viewBtn.layer.cornerRadius = 10
        
        heart = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 30))
        heart.setTitle("♥︎", for: .normal)
        heart.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 30)
        
        addSubview(recipeLbl)
        addSubview(viewBtn)
        addSubview(heart)
        
        // sets the position of the buttons
        viewBtn.translatesAutoresizingMaskIntoConstraints = false
        viewBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        viewBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        heart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
    }
}



