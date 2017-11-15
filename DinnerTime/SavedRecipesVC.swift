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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell") as? RecipesCell
        let dictionary = self.savedRecipeData[indexPath.row]

        cell?.recipeLbl?.text = dictionary["title"] as! String?
        cell?.heart.tag = indexPath.row
        cell?.heart.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.25, alpha:1.0), for: .normal)
        cell?.heart.addTarget(self, action: #selector(deleteRecipe), for: .allEvents)
        
        cell?.viewBtn.tag = indexPath.row
        cell?.viewBtn.addTarget(self, action: #selector(viewRecipeClicked), for: .allEvents)
        
        return cell!
        
    }
    
    func loadRecipesFromFirebase() {
        
        // childAdded is called once for each existing child under the parent, then again if anything is added
        ref.child("recipes").child(CURRENT_USER).observe(DataEventType.childAdded, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : AnyObject]
            
            if (dictionary != nil) {
                self.savedRecipeData.append(dictionary!)
                self.tableView.reloadData()
            }
        })
        
        // checks to see if recipes have been deleted and will delete on firebase
        ref.child("recipes").child(CURRENT_USER).observe(DataEventType.childRemoved, with: { (snapshot) in
            
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
    func deleteRecipe(sender: UIButton) {

        let recipe = self.savedRecipeData[sender.tag]
        let recipeId = recipe["recipe_id"] as! String

        // removes from firebase database first
        ref.child("recipes").child(CURRENT_USER).child(recipeId).removeValue()

    
        
    }
    
    
    // opens url in safari
    func viewRecipeClicked(sender:UIButton) {
        let dictionary = self.savedRecipeData[sender.tag]
        let website = dictionary["source_url"] as! String
        UIApplication.shared.open(URL(string:website)!, options: [:], completionHandler: nil)
        
    }
    

    
    
}
