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
    
    let accountService = AccountService()
    
    var userId: String?
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showIdentInfo(_ sender: Any) {
        
    }
    
    @IBAction func toggleTermsCheckbox() {
        termsCheckbox.toggleCheckState(true)
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let phoneNumber = phoneNumber, let userId = userId else {
            debugPrint("phoneNumber or userId is nil")
            return
        }
        firstNameErrorLabel.text = ""
        lastNameErrorLabel.text = ""
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            firstNameErrorLabel.text = NSLocalizedString("FirstNameError", comment: "")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameErrorLabel.text = NSLocalizedString("LastNameError", comment: "")
            return
        }
        
        /*if passbaseCompleted {
         identErrorLabel.text = ""
         } else {
         identErrorLabel.text = "Bitte vervollständige deine Identitätsverifizierung"
         }*/
        
        // Validation
        //        if /* && passbaseCompleted*/ {
        
        //Add textfield data to user struct
        let userInput = User(uid: userId,
                             //passbaseKey: UserDefaults.standard.string(forKey: "passbaseKey")!,
            credits: 0,
            first_name: firstName,
            last_name: lastName,
            radius: 0,
            phone: phoneNumber)
        
        // Create account
        // TODO: - Show loading circle
        accountService.createAccount(user: userInput)
            .done(on: .main, handleCreateAccountSuccess)
            .recover(on: .main, handleCreateAccountFailure)
            .catch(on: .main, handleCreateAccountFailure)
    }
    
    private func handleCreateAccountSuccess() {
        self.performSegue(withIdentifier: "LoginStep3_to_Map", sender: nil)
    }
    
    private func handleCreateAccountFailure(_ error: Error) {
        self.termsErrorLabel.text = NSLocalizedString("TermsError", comment: "")
    }
}
