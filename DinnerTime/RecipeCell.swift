//
//  SearchedRecipesCell.swift
//  DinnerTime
//
//  Created by Caroline Davis on 25/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var heart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTheCells(recipeLabel: recipeLbl, viewButton: viewBtn)
        
    }
    
    
    
}
