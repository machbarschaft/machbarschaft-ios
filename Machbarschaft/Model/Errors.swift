//
//  Errors.swift
//  Machbarschaft
//
//  Created by Felix Schlegel on 25.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation

//Database (Firestore) errors
public enum DatabaseError: Error{
    
    case entryNotFound
    
    //Error descriptions
    public var errorDescription: String? {
            switch self {
            case .entryNotFound:
                return NSLocalizedString(
                    "Couldn't find any matching database entries.",
                    comment: ""
                )
            }
        }
}
