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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userEmailAndPasswords = [[String: String]]()
    var alreadySignedUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // segues dont work in viewdidLoad
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
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
                self.alerts(message: "Sorry we are unable to authenticate you, please try again")
            case .cancelled:
                print("User cancelled login")
                self.alerts(message: "You have cancelled your login")
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
                self.alerts(message: "Sorry we are unable to authenticate you, please try again")
            } else {
                print("Carol: Successfully authenticated with firebase")
                self.completeSignIn(user: user!)
                
            }
        }
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        
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
        } else {
            self.alerts(message: "Please type something in the login fields")
            activityIndicator.stopAnimating()
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
    
    func alerts(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



