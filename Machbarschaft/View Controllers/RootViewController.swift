//
//  RootViewController.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 12.05.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Here is the place to do some setup

        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        
        var segueIdentifier = "RootViewController_to_MainViewController"
        if Auth.auth().currentUser == nil || !isUserLoggedIn {
            segueIdentifier = "RootViewController_to_LoginStoryboard"
        }
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
