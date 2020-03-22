//
//  NetworkFunctions.swift
//  Machbarschaft
//
//  Created by Florian on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation
import Firebase

class APIClass {
    
    var db: Firestore!

    init() {
        db = Firestore.firestore()
    }
    
    // Example Telephone Number: 90821389123
    func getAccount(number: String) -> Any? {
        var result : Any?
        let docRef = db.collection("Account").whereField("phone_number", isEqualTo: number)
        docRef.getDocuments { (document, error) in
        if let error = error {
                    print("Error getting documents: \(error)")
                    result = nil
                } else {
                    for document in document!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    result = document!.documents
                }
            }
            return result
    }
    
    // Example Order "TmRu3aWu0v8Zc0xQ5AR9"
    func getOrder(orderId: String) -> Any? {
        var result : Any?
        let docRef = db.collection("Order").document(orderId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                result = dataDescription
            } else {
                print("Document does not exist")
                result = nil
            }
        }
        return result
    }
    
    // Flag withStatus can be omitted, then all Statuses are called.
    // Status e.g. "open"
    func getAllOrders(withStatus : String? = nil) -> Any? {
        var result : Any?
        if withStatus != nil {
            db.collection("Order").whereField("status", isEqualTo: withStatus as Any).getDocuments() { (querySnapshot, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                        result = nil
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        result = querySnapshot!.documents
                    }
                }
                return result
        }
        db.collection("Order").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                result = nil
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                result = querySnapshot!.documents
            }
        }
        return result
    }
    
}
