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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? SavedRecipeCell
        let dictionary = self.savedRecipeData[indexPath.row]
        
        cell?.savedRecipeLbl?.text = dictionary["title"] as! String?
        
    
        return cell!
        
    }
    
    func loadRecipesFromFirebase() {
        
        var userId = "123"
    
        ref.child("recipes").child(userId).observe(DataEventType.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : AnyObject] ?? [:]
           
            var recipeId = dictionary["recipe_id"] as! String
            
            
        })
    
    
    }
    

    
    
}
