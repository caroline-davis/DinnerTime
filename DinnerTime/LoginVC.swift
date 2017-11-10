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
import FacebookCore
import FacebookLogin


class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fbButton: FacebookButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toggleSignIn: UISegmentedControl!
    
    var userEmailAndPasswords = [[String: String]]()
    var alreadySignedUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
       //fbButton = LoginButton(readPermissions: [ .publicProfile ])
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        // segues dont work in viewdidLoad
        if let userID =  KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        }
    }
    
    // Once the facebook button is clicked, it fires off this function
    @IBAction func facebookButtonClicked(sender: UIButton) {
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Carol", "Logged In")
                // User succesfully logged in. Contains granted, declined permissions and access token.
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
  
    
    // link the fb log in with firebase authentication
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("CAROL: Unable to autheticate with firebase - \(error)")
            } else {
                print("Carol: Successfully authenticated with firebase")
                self.completeSignIn(user: user!)
                
            }
        }
    }
    
    @IBAction func logIn(_ sender: AnyObject) {
        
        if emailField.text != "" && passwordField.text != "" {
            let email = emailField.text
            let password = passwordField.text
            
            if alreadySignedUp == true {
                // log in - log in with firebase and get their existing user id
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    self.completeSignIn(user: user!)
                }
                
            } else {
                // register new user - create new user and create new user id
                Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                    print(error)
                    self.completeSignIn(user: user!)
                }
                
            }
        }
        
    }
    
    func completeSignIn(user: UserInfo) {
        let keychainResult = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
        print("CAROL: USER: \(user.uid)")
        print("CAROl: Data saved to keychain\(keychainResult)")
        self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
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
