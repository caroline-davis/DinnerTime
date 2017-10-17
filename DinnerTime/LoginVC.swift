//
//  LoginVC.swift
//  DinnerTime
//
//  Created by Caroline Davis on 16/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper



class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toggleSignIn: UISegmentedControl!
    
    var userEmailAndPasswords = [[String: String]]()
    var alreadySignedUp = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // segues dont work in viewdidLoad
        if let userID =  KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("CAROL: \(userID)")
            performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        }
    }
    
    
    @IBAction func logIn(_ sender: AnyObject) {
        
        if emailField.text != "" && passwordField.text != "" {
            let email = emailField.text
            let password = passwordField.text

            if alreadySignedUp == true {
            // log in
            // log in with firebase and get their existing user id
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                let keychainResult = KeychainWrapper.standard.set((user?.uid)!, forKey: KEY_UID)
                }
                
            } else {
                // register new user
                // create new user and create new user id

                Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                    print(error)
                  let keychainResult = KeychainWrapper.standard.set((user?.uid)!, forKey: KEY_UID)
                }
            
            }
        }
        
    }
    
    @IBAction func segmentClicked(_ sender: AnyObject) {
        if(toggleSignIn.selectedSegmentIndex == 0) {
            alreadySignedUp = true
        } else if (toggleSignIn.selectedSegmentIndex == 1) {
            alreadySignedUp = false
        }
            
    }
    

}


// To complete setup for fb, add this OAuth redirect URI to your Facebook app configuration. Learn more: https://firebase.google.com/docs/auth/?authuser=0
// https://dinnertime-cc11a.firebaseapp.com/__/auth/handler
