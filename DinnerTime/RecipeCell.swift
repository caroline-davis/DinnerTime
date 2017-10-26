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
        
        recipeLbl.font = UIFont(name: "Helvetica Neue", size: 14)
        
        viewBtn.backgroundColor = UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0)
        viewBtn?.setTitle("VIEW", for: .normal)
        viewBtn.setTitleColor(.white, for: .normal)
        viewBtn.setTitleColor(UIColor(red:0.14, green:0.13, blue:0.19, alpha:1.0), for: .highlighted)
        viewBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        viewBtn.layer.cornerRadius = 10
        
    }

   

}
