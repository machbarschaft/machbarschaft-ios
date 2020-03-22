//
//  AreaCode.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation

struct AreaCode: Decodable, Equatable {
    let name: String
    let dialCode: String
    let code: String
    
    static func ==(lhs: AreaCode, rhs: AreaCode) -> Bool {
        lhs.dialCode == rhs.dialCode
    }
}
