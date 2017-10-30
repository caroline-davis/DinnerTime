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
    @IBOutlet weak var contentView: UIView!
    
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
    
    func watchRecipes() {
        var userId = "123"
        
        ref.child("recipes").child(userId).observe(DataEventType.childAdded, with: { (snapshot) in
            let recipe = snapshot.value as? [String : AnyObject] ?? [:]
            var recipeId = recipe["recipe_id"] as! String
            for (index, dictionary) in self.tableViewData.enumerated() {
                var currentRecipe = dictionary
                if currentRecipe["recipe_id"] as! String == recipeId {
                    currentRecipe["saved"] = true
                    self.tableViewData[index] = currentRecipe
                    self.tableView.reloadData()
                }
            }
        })
        
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
    print(sender.tag)
        let dictionary = self.tableViewData[sender.tag]
        let website = dictionary["source_url"] as! String
        let title = dictionary["title"] as! String
        let recipeId = dictionary["recipe_id"] as! String
        var userId = "123"
        
        ref.child("recipes").child(userId).child(recipeId).setValue(dictionary)
//        if sender.isSelected == false {
//            sender.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.25, alpha:1.0), for: .normal)
//            sender.isSelected = true
//            // add this recipe to the saved recipes list for the database
//        } else {
//            sender.setTitleColor(UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0), for: .normal)
//            sender.isSelected = false
//            // delete this recipe off the saved recipes list for the database
//        }
        
    }
    
    
    func typeInIngredients() {
        stringOfWords = usersBrowserField.text
        
        // if string isnt empty
        if stringOfWords != "" {
            
            // if string has more than 1 word add the + sign inbetween for the API String
            if stringOfWords.components(separatedBy: " ").count > 0 {
                stringOfWords = stringOfWords.replacingOccurrences(of: " ", with: "+")
            }
        }
        searchRecipes()
    }
    
    func searchRecipes() {
        
        // make the request to the API - remember to add the ! to the stringofwords so its not optional and works
        print("\(API_ADDRESS)\(SEARCH_RECIPES)\(API_KEY)&q=\(stringOfWords)")
        Alamofire.request("\(API_ADDRESS)\(SEARCH_RECIPES)\(API_KEY)&q=\(stringOfWords!)").responseJSON { response in
            
            // clear tableViewData
            self.tableViewData.removeAll()
            
            if let value = response.result.value as? [String: Any] {
                if let dictionaries = value["recipes"] as? [[String: Any]] {
                    if dictionaries.count > 0 {
                        
                        // iterate over array of dictionaries... in db?
                        for dictionary in dictionaries {
                            var recipe = dictionary
                            self.searchCurrentSavedRecipes(recipeId: dictionary["recipe_id"] as! String, completion: { result in
                                
                                recipe["saved"] = result
                                self.tableViewData.append(recipe)
                                self.tableView.reloadData()
                            
                            })
                        }
                        
                    }
                }
            }
        }
    }
    
    func searchCurrentSavedRecipes(recipeId: String, completion: @escaping (_ hasSaved: Bool) -> Void) {
        var userId = "123"
        ref.child("recipes").child(userId).child(recipeId).observeSingleEvent(of: .value, with: { (snapshot) in

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
    
    
}




