//
//  FacebookButton.swift
//  DinnerTime
//
//  Created by Caroline Davis on 18/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class FacebookButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // colour for fb
        layer.backgroundColor = UIColor(red:0.27, green:0.36, blue:0.61, alpha:1.0).cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // makes the button 100% round
        layer.cornerRadius = self.frame.width / 2
  
    }



   
}
