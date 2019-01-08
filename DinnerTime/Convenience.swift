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
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
