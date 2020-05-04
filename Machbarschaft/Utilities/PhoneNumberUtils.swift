//
//  PhoneNumberUtils.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 03.05.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation

class PhoneNumberUtils {
    static func validatePhone(phone: String) -> Bool {
        let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
}
