//
//  BrowseRecipesVC.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Alamofire

class BrowseRecipesVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usersBrowserField: UITextField!
    
    var stringOfWords: String!
    
    var website = String()
    var tableViewData = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersBrowserField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self

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
        website = dictionary["f2f_url"] as! String
        
        cell?.recipeLbl?.text = dictionary["title"] as! String?
        cell?.viewBtn.addTarget(self, action: #selector(viewRecipeClicked), for: .allEvents)
        
        return cell!
    }
    
    // opens url in safari
    func viewRecipeClicked() {
        UIApplication.shared.openURL(URL(string: website)!)
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
            
            if let value = response.result.value as? [String: Any] {
                if let dictionaries = value["recipes"] as? [[String: Any]] {
                    if dictionaries.count > 0 {
                        self.tableViewData = dictionaries
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
    }
    
    
}




