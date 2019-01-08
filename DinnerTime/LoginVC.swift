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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userEmailAndPasswords = [[String: String]]()
    var alreadySignedUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.emailField.delegate = self
            self.passwordField.delegate = self
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // segues dont work in viewdidLoad
        super.viewDidAppear(animated)
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        }
    }
    
    // link the fb log in with firebase authentication
    func firebaseAuth(_ credential: AuthCredential) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if (error != nil) {
                print("Sorry we are unable to authenticate you, please try again")
                self.alerts(message: "Sorry we are unable to authenticate you, please try again")
            } else {
                self.completeSignIn(user: user! as! UserInfo)
            }
        }
    }
    
    
    @IBAction func logIn(_ sender: UIButton) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        if emailField.text != "" && passwordField.text != "" {
            let email = emailField.text
            let password = passwordField.text
            
            if alreadySignedUp == true {
                // log in - log in with firebase and get their existing user id
                Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
                    
                    if (error != nil) {
                        self.alerts(message: "\(error!.localizedDescription)")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    } else {
                        let user = authResult?.user
                        self.completeSignIn(user: user!)
                    }
                }
            } else {
                // register new user - create new user and create new user id
                Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                    
                    if (error != nil) {
                        self.alerts(message: "\(error!.localizedDescription)")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    } else {
                        let user = authResult?.user
                        self.completeSignIn(user: user!)
                    }
                }
            }
        } else {
            self.alerts(message: "Please type something in the login fields")
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func completeSignIn(user: UserInfo) {
        
        KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
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



