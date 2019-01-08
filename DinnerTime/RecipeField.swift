//
//  RecipeField.swift
//  DinnerTime
//
//  Created by Caroline Davis on 26/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class RecipeField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = indentView
        self.leftViewMode = .always
    }
}
