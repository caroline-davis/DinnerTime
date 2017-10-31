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
        // log out code
        
        // remove saved user id key
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("CAROL: ID removed from keychain \(keychainResult)")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("CAROL: Error signing out: %@", signOutError)
        }
        
        
    }
    
    
    
    
}
