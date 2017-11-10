//
//  BrowseRecipesVC.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class BrowseRecipesVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usersBrowserField: UITextField!
    var stringOfWords: String!
    var tableViewData = [[String: Any]]()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        watchRecipes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersBrowserField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        typeInIngredients()
    }
    
    // when enter is pressed keyboard is dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    // puts the data in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedRecipeCell") as? RecipeCell
        let dictionary = self.tableViewData[indexPath.row]
        
        cell?.recipeLbl?.text = dictionary["title"] as! String?
        cell?.viewBtn.tag = indexPath.row
        cell?.viewBtn.addTarget(self, action: #selector(viewRecipeClicked), for: .allEvents)
        
        // if dictionary["saved"] is true, change the color of the heart
        let saved = dictionary["saved"] as! Bool
        let id = dictionary["recipe_id"] as! String
        
        if saved == true {
            cell?.heart.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.25, alpha:1.0), for: .normal)
        } else {
            cell?.heart.setTitleColor(UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0), for: .normal)
        }
        cell?.heart.tag = indexPath.row
        
        return cell!
    }
    
    
    // opens url in safari
    func viewRecipeClicked(sender:UIButton) {
        let dictionary = self.tableViewData[sender.tag]
        let website = dictionary["source_url"] as! String
        UIApplication.shared.open(URL(string:website)!, options: [:], completionHandler: nil)
        
    }
    
    // saves the recipe for the recipe book in saved recipes vc
    @IBAction func clickHeart(_ sender: UIButton) {
        let dictionary = self.tableViewData[sender.tag]
        let recipeId = dictionary["recipe_id"] as! String
        
        if dictionary["saved"] as! Bool == false {
            ref.child("recipes").child(CURRENT_USER).child(recipeId).setValue(dictionary)
        } else {
            ref.child("recipes").child(CURRENT_USER).child(recipeId).removeValue()
        }
        
    }
    
    // users types in ingredients or food.
    func typeInIngredients() {
        stringOfWords = usersBrowserField.text
        
        // if string isnt empty
        if stringOfWords != "" {
            
            // if string has more than 1 word add the + sign inbetween for the API String
            if stringOfWords.components(separatedBy: " ").count > 0 {
                stringOfWords = stringOfWords.replacingOccurrences(of: " ", with: "+")
            }
        } else if stringOfWords == "" {
            alerts(message: "Please type something in this field")
            return
        }
        searchRecipes()
    }
    
    
    // searches for recipes with the API
    func searchRecipes() {
        
        // make the request to the API - remember to add the ! to the stringofwords so its not optional and works
        Alamofire.request("\(API_ADDRESS)\(SEARCH_RECIPES)\(API_KEY)&q=\(stringOfWords!)").responseJSON { response in
            
            // clear tableViewData
            self.tableViewData.removeAll()
            
            if let value = response.result.value as? [String: Any] {
                if let dictionaries = value["recipes"] as? [[String: Any]] {
                    if dictionaries.count > 0 {
                        
                        // iterate over array of dictionaries returned from api
                        for dictionary in dictionaries {
                            var recipe = dictionary
                            self.searchCurrentSavedRecipes(recipeId: dictionary["recipe_id"] as! String, completion: { result in
                                
                                recipe["saved"] = result
                                self.tableViewData.append(recipe)
                                self.tableView.reloadData()
                                
                            })
                        }
                        
                    } else if dictionaries.count <= 0 {
                        self.alerts(message: "Sorry there are no recipes found, please try again")
                    }
                }
            }
        }
    }
    
    func searchCurrentSavedRecipes(recipeId: String, completion: @escaping (_ hasSaved: Bool) -> Void) {

        
        // check to see if recipe is in the saved recipes already. then we can set the bool for the heart as full or not
        ref.child("recipes").child(CURRENT_USER).child(recipeId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            if value != nil {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // checks the current dictionary to see if the recipe is there and if its to be saved or not.
    func checkingRecipe(recipeSaved: Bool, snapshot: DataSnapshot) {
        let recipe = snapshot.value as? [String : AnyObject] ?? [:]
        let recipeId = recipe["recipe_id"] as! String
        
        for (index, dictionary) in tableViewData.enumerated() {
            var currentRecipe = dictionary
            if currentRecipe["recipe_id"] as! String == recipeId {
                currentRecipe["saved"] = recipeSaved
                self.tableViewData[index] = currentRecipe
                self.tableView.reloadData()
            }
        }
        
    }
    
    // checks to see movement of recipes (whether user has added or deleted any off the saved recipes array
    func watchRecipes() {
        
        
        // checks to see if recipes have been liked and added to firebase
        ref.child("recipes").child(CURRENT_USER).observe(DataEventType.childAdded, with: { (snapshot) in
            
            self.checkingRecipe(recipeSaved: true, snapshot: snapshot)
        })
        
        // checks to see if recipes have been deleted and will delete on firebase
        ref.child("recipes").child(CURRENT_USER).observe(DataEventType.childRemoved, with: { (snapshot) in
            self.checkingRecipe(recipeSaved: false, snapshot: snapshot)
        })
        
    }
    
    func alerts(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}




