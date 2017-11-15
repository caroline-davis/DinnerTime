//
//  Convenience.swift
//  DinnerTime
//
//  Created by Caroline Davis on 15/11/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//


import UIKit

extension UIViewController {
    
    func alerts(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
