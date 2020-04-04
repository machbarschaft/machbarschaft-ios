//
//  LoginStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
//import Passbase
import M13Checkbox
import Firebase

class LoginStep3ViewController: SuperViewController/*, PassbaseDelegate */{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var identTextField: UITextField!
    @IBOutlet weak var identErrorLabel: UILabel!
    
    @IBOutlet weak var termsCheckbox: M13Checkbox!
    @IBOutlet weak var termsErrorLabel: UILabel!
    
    //Passbase variable
    //var passbaseCompleted:Bool = false
    
    let accountService = AccountService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegate object to self
        //Passbase.delegate = self
        
    }
    
    @IBAction func showIdentInfo(_ sender: Any) {
        
    }
    
    /*Passbase stubs
    func didCompletePassbaseVerification(authenticationKey: String) {
        
        //Change passbase variable
        passbaseCompleted = true
        
        //Write authentication Key to userdefaults
        UserDefaults.standard.set(authenticationKey, forKey: "passbaseKey")
        
    }
    
    func didCancelPassbaseVerification() {
        
        //Change passbase variable
        passbaseCompleted = false

    }*/
    
    @IBAction func toggleTermsCheckbox() {
        termsCheckbox.toggleCheckState(true)
    }
    
    @IBAction func signup(_ sender: Any) {
        
        //Validation messages
        if firstNameTextField.text!.isEmpty{
            firstNameErrorLabel.text = "Bitte gebe deinen Vornamen ein"
        }else{
            firstNameErrorLabel.text = ""
        }
        
        if lastNameTextField.text!.isEmpty{
            lastNameErrorLabel.text = "Bitte gebe deinen Nachnamen ein"
        }else{
            lastNameErrorLabel.text = ""
        }
        
        /*if passbaseCompleted{
            identErrorLabel.text = ""
        }else{
            identErrorLabel.text = "Bitte vervollständige deine Identitätsverifizierung"
        }*/
        
        //Validation
        if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty/* && passbaseCompleted*/{
            
            //Add textfield data to user struct
            let userInput = User(uid: UserDefaults.standard.string(forKey: "UID")!,
                                 //passbaseKey: UserDefaults.standard.string(forKey: "passbaseKey")!,
                                 credits: 0,
                                 first_name: firstNameTextField.text!,
                                 last_name: lastNameTextField.text!,
                                 radius: 0,
                                 phone: UserDefaults.standard.string(forKey: "phone")!)
            
            //Create account
            //TODO: Show loading circle
            accountService.createAccount(user: userInput){ success in
                
                if success{
                    
                    self.performSegue(withIdentifier: "LoginStep3_to_Map", sender: nil)
                    
                }else{
                    
                    //TODO: Create an own label
                    self.termsErrorLabel.text = "Beim erstellen deines Accounts ist ein Fehler aufgetreten. Bitte versuche es erneut."
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
