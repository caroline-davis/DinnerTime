//
//  FavRecipes.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire

class SavedRecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var savedRecipeData = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadRecipesFromFirebase()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedRecipeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedRecipeCell") as? SavedRecipeCell
        let dictionary = self.savedRecipeData[indexPath.row]
        
        cell?.savedRecipeLbl?.text = dictionary["title"] as! String?
        cell?.savedHeart.tag = indexPath.row
        
        return cell!
        
    }
    
    func loadRecipesFromFirebase() {
        
        var userId = "123"
        
        // childAdded is called once for each existing child under the parent, then again if anything is added
        ref.child("recipes").child(userId).observe(DataEventType.childAdded, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : AnyObject]
            
            if (dictionary != nil) {
                self.savedRecipeData.append(dictionary!)
                self.tableView.reloadData()
            }
        })
        
        // checks to see if recipes have been deleted and will delete on firebase
        ref.child("recipes").child(userId).observe(DataEventType.childRemoved, with: { (snapshot) in
            
            // the way to get access to the snapshot of data from firebase docs
            let value = snapshot.value as? [String : AnyObject] ?? [:]
            let recipeId = value["recipe_id"] as! String
            
            //checking like 'for recipe in savedrecipedata' but also giving us an index so we can delete it
            for (index, recipe) in self.savedRecipeData.enumerated(){
                if recipe["recipe_id"] as! String == recipeId {
                    self.savedRecipeData.remove(at: index)
                }
            }
            // reloading the data when the deletion has been completed from the savedRecipesArray
            self.tableView.reloadData()

        })
    }
    
    // if the heart is clicked on this vc we need to remove the cell from the ui and also from the saved recipes array. We also need to delete recipe off the array in firebase.
    @IBAction func deleteRecipe(sender: UIButton) {
        var userId = "123"
        let recipe = self.savedRecipeData[sender.tag]
        let recipeId = recipe["recipe_id"] as! String

        // removes from firebase database first
        ref.child("recipes").child(userId).child(recipeId).removeValue()
        
        
        
    }
    

    
    
}
