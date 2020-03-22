//
//  LoginStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import M13Checkbox

class LoginStep3ViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var identTextField: UITextField!
    
    @IBOutlet weak var termsCheckbox: M13Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        
    }
    
    @IBAction func showIdentInfo(_ sender: Any) {
        
    }
    
    @IBAction func toggleTermsCheckbox() {
        termsCheckbox.toggleCheckState(true)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
