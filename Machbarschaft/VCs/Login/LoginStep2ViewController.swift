//
//  LoginStep2ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginStep2ViewController: SuperViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func requestNewCode(_ sender: Any) {
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        // TODO: validations here
        
        let code:String = codeTextField.text!
        
        //Get verification ID from storage
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: code)
        
        //Test
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            //Error handling
            if let error = error {
            print(error)
            return
            }
            
            // User is signed in
            // ...
            if authResult?.additionalUserInfo!.isNewUser ?? true {
                print("New user!")
            }else{
                
                return
                
            }
            //Connect to Database
            
        }
        
        performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
