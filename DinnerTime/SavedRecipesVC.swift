//
//  FavRecipes.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit

class SavedRecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
   // var savedRecipes: [[String:String]]!
    var savedRecipes = [
    ["FavColour": "Green", "FavSong": "The Lion Sleeps Tonight"],
    ["FavColour": "Purple", "FavSong": "Green Onions"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell")!
       let dictionary = self.savedRecipes[indexPath.row]
      
        
        cell.textLabel?.text = dictionary["FavColour"]
        //        cell.detailTextLabel?.text = dictionary["apron"]
        return cell

    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }


}
