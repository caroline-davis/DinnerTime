//
//  DataService.swift
//  DinnerTime
//
//  Created by Caroline Davis on 18/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class DataService {
    
    static let ds = DataService()
    
    func logout(uid: String) {
        
        // remove saved user id key
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("CAROL: Error signing out: %@", signOutError)
        }  
    }
    
    func removeRecipe(recipeId: String) {
        ref.child("recipes").child(CURRENT_USER).child(recipeId).removeValue()
    }
    
    
}
