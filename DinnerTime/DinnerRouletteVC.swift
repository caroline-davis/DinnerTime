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
    
    @IBOutlet weak var pizza: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var viewRecipeBtn: UIButton!
    @IBOutlet weak var resultsView: UIView!
    
    var recipes: [[String: AnyObject]]!
    var angle: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.resultsView.isHidden = true
    }
    
    @IBAction func randomRecipeGenerator() {
        
        var newAngle: CGFloat = angle + 180
        angle = newAngle
        
        print("CAROL THIS IS NEW ANGLE\(newAngle)")
        print("carol this is angle \(angle)")
    
        // rotates the uiview
        UIView.animate(withDuration: 2.0, animations: {
            self.pizza.transform = CGAffineTransform(rotationAngle: (newAngle * CGFloat(M_PI)) / 180)
        })

        
        // makes the code below begin after 2 seconds aka. after the pizza has spun!!!!
        let when = DispatchTime.now() + 1.8
        DispatchQueue.main.asyncAfter(deadline: when) {
        
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
                self.recipeLabel.text = (recipeName?.capitalized)! as String
                self.resultsView.isHidden = false
            } else {
                self.recipeLabel.text  = "No Name Recipe"
                self.resultsView.isHidden = false
            }
            
        })
        
        }
    }


}
