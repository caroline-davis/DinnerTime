//
//  BrowseRecipesVC.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Alamofire

class BrowseRecipesVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usersBrowserField: UITextField!
    var stringOfWords: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersBrowserField.delegate = self

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        typeInIngredients()
    }
    
    // when enter is pressed keyboard is dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    @IBAction func searchRecipes(_ sender: AnyObject) {
        // make the request to the API
        print("\(API_ADDRESS)\(SEARCH_RECIPES)\(API_KEY)&q=\(stringOfWords)")
        Alamofire.request("\(API_ADDRESS)\(SEARCH_RECIPES)\(API_KEY)&q=\(stringOfWords!)").responseJSON { response in
            print(response.result.value)
            if let json = response.result.value {
                print("helloooo")
                print("CAROL: JSON: \(json)")
            }
            
        }
    }
    
    
    func typeInIngredients() {

        stringOfWords = usersBrowserField.text
        
        if stringOfWords.components(separatedBy: " ").count > 0 {
            print("CAROL STRING HERE", stringOfWords)
            stringOfWords = stringOfWords.replacingOccurrences(of: " ", with: "+")
            print("CAROL STRING HERE", stringOfWords)
        } else {
          print("There was a\(LocalizedError.self)")
        }
        
    }
    

    
}




