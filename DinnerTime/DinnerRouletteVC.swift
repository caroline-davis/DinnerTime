//
//  DinnerRouletteVC.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class DinnerRouletteVC: UIViewController {
    
    @IBOutlet weak var recipeLabel: UILabel!
    var recipes: [[String: AnyObject]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }
    
    @IBAction func randomRecipeGenerator() {
        
        let userId = "123"
        ref.child("recipes").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : [String: AnyObject]] ?? [:]
            
            // remove the keys, we just want the values
            let values = Array(dictionary.values) as [[String: AnyObject]]

            self.recipes = values
            
            // this will give us the number of the random index is has chosen
            let randomRecipe = Int(arc4random_uniform(UInt32(self.recipes.count)))
            
            // this will select the chosen index in the recipes array
            let recipe = self.recipes[randomRecipe]
            
            // need to extract the title of the recipe + check if it is empty
            let recipeName = recipe["title"]
            if recipeName != nil {
                self.recipeLabel.text = recipeName as? String
            } else {
                self.recipeLabel.text  = "No Name Recipe" 
            }
            
        })
        
    }


}
