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
import PromiseKit

public class AccountService {
    
    let db = Firestore.firestore()
    
    // Function to send a request code
    func requestCode(phoneNumber: String) -> Promise<String> {
        return Promise { resolver in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
                if let error = error {
                    resolver.reject(AuthenticationError.firebaseError(firebaseErrorDescription: error.localizedDescription,
                                                                      firebaseErrorCode: error._code))
                } else if let id = verificationId {
                    resolver.fulfill(id)
                } else {
                    resolver.reject(AuthenticationError.fatal)
                }
            }
        }
    }
    
    // Function that creates a new account
    func createAccount(user: User) -> Promise<Void> {
        return createSettings(for: user).then(updateUserName)
    }
    
    func signIn(with credential: PhoneAuthCredential) -> Promise<AuthDataResult> {
        return Promise { resolver in
            Auth.auth().signIn(with: credential) { (result, optionalError) in
                if let error = optionalError {
                    debugPrint("AccountService login error: \(error.localizedDescription)")
                    resolver.reject(AuthenticationError.firebaseError(firebaseErrorDescription: error.localizedDescription,
                                                                      firebaseErrorCode: error._code))
                    return
                }
                if let result = result {
                    resolver.fulfill(result)
                    return
                }
                resolver.reject(AuthenticationError.fatal)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func updateUserName(for user: User) -> Promise<Void> {
        return Promise { resolver in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(user.first_name) \(user.last_name)"
            changeRequest?.commitChanges { optionalError in
                if let error = optionalError {
                    debugPrint("Error updating user information: \(error)")
                    resolver.reject(AuthenticationError.firebaseError(firebaseErrorDescription: error.localizedDescription,
                                                                      firebaseErrorCode: error._code))
                    return
                }
                debugPrint("User information updated.")
                resolver.fulfill(())
            }
        }
    }
    
    private func createSettings(for user: User) -> Promise<User> {
        let settingsData = ["settings": ["notify_nearby_orders": "false"]]
        
        return Promise { resolver in
            
            // create account document in database
            db.collection("account").document(user.uid).setData(settingsData) { optionalError in
                if let error = optionalError {
                    debugPrint("Error creating account document: \(error)")
                    resolver.reject(DatabaseError.firestoreError(firestoreErrorDescription: error.localizedDescription,
                                                                 firestoreErrorCode: error._code))
                    return
                }
                resolver.fulfill(user)
            }
        }
    }
    
    // Function that gets the account document
    public func getDocumentID(for uid: String) -> Promise<String> {
        return Promise { resolver in
            let query = db.collection("account").document(uid)
            
            //Execute query
            query.getDocument { (document, optionalError) in
                if let error = optionalError {
                    debugPrint("Error getting document: \(error)")
                    resolver.reject(DatabaseError.firestoreError(firestoreErrorDescription: error.localizedDescription,
                                                                 firestoreErrorCode: error._code))
                    return
                }
                
                // Document exists
                if let document = document, document.exists {
                    resolver.fulfill(document.documentID)
                } else {
                    resolver.reject(DatabaseError.entryNotFound)
                }
            }
        }
    }
}
