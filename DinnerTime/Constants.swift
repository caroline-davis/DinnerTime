//
//  Constants.swift
//  DinnerTime
//
//  Created by Caroline Davis on 17/10/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import SwiftKeychainWrapper

let KEY_UID = "uid"
let API_KEY = "7bbe6ecb98ca9c0e9ec589c0ea4123e1"

let API_ADDRESS = "https://food2fork.com/api"
let SEARCH_RECIPES = "/search?key="
let GET_RECIPES = "/get"

// user id
var CURRENT_USER = KeychainWrapper.standard.string(forKey: KEY_UID)!

var ref: DatabaseReference!
