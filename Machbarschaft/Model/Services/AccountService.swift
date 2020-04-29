//
//  AccountService.swift
//  Machbarschaft
//
//  Created by Felix Schlegel on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public class AccountService {
    
    //Initialise Database
    let db = Firestore.firestore()
    
    //Function that validates the phone number
    public func validatePhone(phone: String) -> Bool{
        
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        
        return result
        
    }
    
    //Function to send a request code
    public func requestCode(phoneNumber: String){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                return
            }
            
            //Save the verification ID to userDefaults
            UserDefaults.standard.set(verificationID!, forKey: "authVerificationID")
            
        }
        
    }
        
    //Function that creates a new account
    public func createAccount(user: User, completion: @escaping (Bool) -> Void){
                
        // create account document in database
        db.collection("account").document(user.uid).setData([
            "settings": [
                "notify_nearby_orders": "false"
            ]
        ]){ err in
            if let err = err {
                print("Error creating account document: \(err)")
                completion(false)
            } else {
                print("Account document created")
                
                // add name to firebase auth
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = "\(user.first_name) \(user.last_name)"
                changeRequest?.commitChanges { err in
                    if let err = err {
                        print("Error updating user information: \(err)")
                        completion(false)
                    } else {
                        print("User information updated.")
                        print("User's name: " + Auth.auth().currentUser!.displayName!)
                        completion(true)
                    }
                }
            }
            
        }
        
    }
    
    //Function that gets the account document
    public func getDocumentID(forUID: String, completion: @escaping (Result<String,DatabaseError>) -> Void) {
        
        let query = db.collection("account").document(forUID)

        //Execute query
        query.getDocument() { (document, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else {

                    //Document exists
                    if let document = document, document.exists {
                        completion(.success(document.documentID))

                    }else{

                        //Raise error
                        completion(.failure(.entryNotFound))

                    }

                }
        }
        
    }
    
}
