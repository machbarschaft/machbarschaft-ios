//
//  Errors.swift
//  Machbarschaft
//
//  Created by Felix Schlegel on 25.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation

//Database (Firestore) errors
public enum DatabaseError: Error {
    
    case entryNotFound
    case firestoreError(firestoreErrorDescription: String, firestoreErrorCode: Int)
    
    public var errorDescription: String? {
        switch self {
        case .firestoreError:
            return NSLocalizedString("DatabaseErrorsFirestore", comment: "Firestore error occured")
        case .entryNotFound:
            return NSLocalizedString(
                "Couldn't find any matching database entries.",
                comment: ""
            )
        }
    }
}

enum AuthenticationError: LocalizedError {
    case fatal
    case firebaseError(firebaseErrorDescription: String, firebaseErrorCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .firebaseError:
            return NSLocalizedString("AuthenticationErrorsFirebase", comment: "Firebase error occured")
        case .fatal:
            return NSLocalizedString("AuthenticationErrorsFatal", comment: "Fatal error occured")
        }
    }
}
