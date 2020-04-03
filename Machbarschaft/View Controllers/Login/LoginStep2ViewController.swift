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
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    let accountService = AccountService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func requestNewCode(_ sender: Any) {
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        let code:String = codeTextField.text!
        
        //Check if code is 6 digits
        if code.count == 6 {
            
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
                    
                    //Show error message
                    self.codeErrorLabel.text = "Ups! Dein eingegebener Code ist falsch"
                    
                    return
                }
                
                // User is signed in
                // ...
                print("Phone number authentication successful!")
                
                //Clear error label
                self.codeErrorLabel.text = ""
                
                //Get user id and save it to UserDefaults
                let userID:String = (authResult?.user.uid)!
                UserDefaults.standard.set(userID, forKey: "UID")

                //Check if Phone number is registered
                if authResult?.additionalUserInfo!.isNewUser ?? true {

                    //Go to register view 3
                    self.performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
                    
                }else{
                    
                    //Save documentID to user defaults
                    self.accountService.getDocumentID(forUID: userID){ result in
                        
                        //TODO: If getDocumentID
                        switch result{
                            
                        case .success(let docID):
                            
                            //Complete Account exists
                            UserDefaults.standard.set(docID, forKey: "docID")
                            
                            //GOTO: MapView
                            self.performSegue(withIdentifier: "LoginStep2_to_Map", sender: nil)
                            
                            break
                            
                        case .failure(let error):
                            
                            //Print error
                            if let errorText:String = error.errorDescription{
                                print(errorText)
                            }
                            
                            //Proceed to Step3 Viewcontroller as phone number exists, but is associated to no account
                            self.performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
                            break
                            
                        }
                        
                        
                        
                    }
                    
                    return
                }
                
            }
            
        }else{
            
            //Show error message
            codeErrorLabel.text = "Der Code muss 6-stellig sein"
            
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
