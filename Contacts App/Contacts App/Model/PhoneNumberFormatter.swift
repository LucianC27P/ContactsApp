//
//  PhoneNumberFormatter.swift
//  Contacts App
//
//  Created by Lucian Cristea on 14.09.2023.
//

import Foundation

class PhoneNumberFormatter {

    static func formatAndValidate(_ phoneNumber: String) -> String {
        let numericString = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let maxLength = 10
        let formattedNumber: String
        
        if numericString.count <= maxLength {
            formattedNumber = formatPhoneNumber(numericString)
        } else {
            let startIndex = numericString.index(numericString.startIndex, offsetBy: maxLength)
            let truncatedString = String(numericString.prefix(upTo: startIndex))
            formattedNumber = formatPhoneNumber(truncatedString)
        }
        
        return formattedNumber
    }
    
    private static func formatPhoneNumber(_ phoneNumber: String) -> String {
        if phoneNumber.count >= 2 {
            var formattedNumber = phoneNumber.hasPrefix("07") ? phoneNumber : "07\(phoneNumber)"
            
            for index in stride(from: 4, to: formattedNumber.count, by: 4) {
                let insertionIndex = formattedNumber.index(formattedNumber.startIndex, offsetBy: index)
                formattedNumber.insert(" ", at: insertionIndex)
            }
            
            return formattedNumber
        } else {
            return phoneNumber
        }
    }
}
