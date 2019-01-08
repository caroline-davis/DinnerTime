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
    var randomRecipe: Int!
    var angle: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        DispatchQueue.main.async {
            self.resultsView.isHidden = true
            self.viewRecipeBtn.isHidden = true
        }
    }
    
    @IBAction func randomRecipeGenerator() {
        
        spinPizza()
        
        // makes the code below begin after 2 seconds aka. after the pizza has spun!!!!
        let when = DispatchTime.now() + 1.8
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            ref.child("recipes").child(CURRENT_USER).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as? [String : [String: AnyObject]] ?? [:]
                
                // remove the keys, we just want the values
                let values = Array(dictionary.values) as [[String: AnyObject]]
                self.recipes = values
                
                if self.recipes.count != 0 {
                    
                    // this will give us the number of the random index it has chosen
                    self.randomRecipe = Int(arc4random_uniform(UInt32(self.recipes.count)))
                    // this will select the chosen index in the recipes array
                    let recipe = self.recipes[self.randomRecipe]
                    
                    // need to extract the title of the recipe + check if it is empty
                    let recipeName = recipe["title"]
                    if recipeName != nil {
                        self.recipeLabel.text = (recipeName?.capitalized)! as String
                        self.resultsView.isHidden = false
                        self.viewRecipeBtn.isHidden = false
                    } else {
                        self.recipeLabel.text  = "No Name Recipe"
                        self.resultsView.isHidden = false
                        self.viewRecipeBtn.isHidden = false
                    }
                    
                } else {
                    self.alerts(message: "Please add a recipe to your cook book first")
                }
            })
        }
    }
    
    func spinPizza() {
        
        // gets the angle to change when the button is clicked to continually do 360 spins
        let newAngle: CGFloat = angle + 180
        angle = newAngle
        
        // rotates the uiview
        UIView.animate(withDuration: 2.0, animations: {
            self.pizza.transform = CGAffineTransform(rotationAngle: (newAngle * CGFloat(Double.pi)) / 180)
        })
    }
    
    @IBAction func openViewButton(sender: UIButton) {
        
        // gets the randomIndex chose from arc4random and gets the URL... opens it in safari
        let recipe = self.recipes[self.randomRecipe]
        let recipeURL = recipe["source_url"] as! String
        UIApplication.shared.open(URL(string: recipeURL)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
