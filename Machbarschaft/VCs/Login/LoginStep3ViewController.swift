//
//  LoginStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import M13Checkbox
import Firebase

class LoginStep3ViewController: SuperViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var identTextField: UITextField!
    @IBOutlet weak var identErrorLabel: UILabel!
    
    @IBOutlet weak var termsCheckbox: M13Checkbox!
    @IBOutlet weak var termsErrorLabel: UILabel!
    
    let handler:RegisterHandler = RegisterHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showIdentInfo(_ sender: Any) {
        
    }
    
    @IBAction func toggleTermsCheckbox() {
        termsCheckbox.toggleCheckState(true)
    }
    
    @IBAction func signup(_ sender: Any) {
        // TODO: validations here
        
        //Add textfield data to user struct
        let userInput = User(uid: UserDefaults.standard.string(forKey: "UID")!,
                             credits: 0,
                             first_name: firstNameTextField.text!,
                             last_name: lastNameTextField.text!,
                             radius: 0,
                             phone: UserDefaults.standard.string(forKey: "phone")!)
        
        //Create account
        //TODO: Show loading circle
        handler.createAccount(user: userInput){ success in
            
            if success{
                
                self.performSegue(withIdentifier: "LoginStep3_to_Map", sender: nil)
                
            }else{
                
                //Show error message
                print("Error creating account")
                
            }
            
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
