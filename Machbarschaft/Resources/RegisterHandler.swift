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

public class RegisterHandler{
    
    //Initialise Database
    let db = Firestore.firestore()
    
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
    
    //TODO: Function that checks if an account associated to UID exists
    
    //Function that creates an account
    public func createAccount(user: User, completion: @escaping (Bool) -> Void){
                
        //Add Valus to Database
        var ref: DocumentReference? = nil
        ref = db.collection("Account").addDocument(data: [
            "uid": user.uid,
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
    public func getDocumentID(forUID: String, completion: @escaping (String) -> Void) {
        
        let query = db.collection("Account").whereField("uid", isEqualTo: forUID)
        
        //Execute query
        query.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    let document = querySnapshot!.documents.first
                    completion(document!.documentID)
                    
                }
        }
        
    }
    
}
