//
//  RegisterHandler.swift
//  Machbarschaft
//
//  Created by Felix Schlegel on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public class RegisterHandler {
    
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
        
    //Function that creates an account
    public func createAccount(user: User, completion: @escaping (Bool) -> Void){
                
        //Add Valus to Database
        var ref: DocumentReference? = nil
        ref = db.collection("Account").addDocument(data: [
            "uid": user.uid,
            "passbaseKey": user.passbaseKey,
            "credits": user.credits,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "radius": user.radius,
            "phone": user.phone
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                //Write document ID to UserDefaults
                UserDefaults.standard.set(ref!.documentID, forKey: "docID")
                
                completion(true)
            }
        }
       
    }
    
    //Function that gets the document ID relating to UID
    public func getDocumentID(forUID: String, completion: @escaping (Result<String,DatabaseError>) -> Void) {
        
        let query = db.collection("Account").whereField("uid", isEqualTo: forUID)
        
        //Execute query
        query.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    //Document exists
                    if let document = querySnapshot!.documents.first {
                        
                        completion(.success(document.documentID))
                        
                    }else{
                        
                        //Raise error
                        completion(.failure(.entryNotFound))
                        
                    }
                    
                }
        }
        
    }
    
}
