//
//  SavedRecipeCell.swift
//  DinnerTime
//
//  Created by Caroline Davis on 31/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class SavedRecipeCell: UITableViewCell {
    
    @IBOutlet weak var savedRecipeLbl: UILabel!
    @IBOutlet weak var savedViewBtn: UIButton!
    @IBOutlet weak var savedHeart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTheCells(recipeLabel: savedRecipeLbl, viewButton: savedViewBtn)
    }
    
    
    
}
