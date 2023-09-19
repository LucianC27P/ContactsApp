//
//  StringExtension.swift
//  Contacts App
//
//  Created by Lucian Cristea on 10.09.2023.
//

import Foundation

extension String {
   var numbers: String {
      return filter { "0"..."9" ~= $0 }
   }
   
   func extractInitials() -> String {
      let nameComponents = self.components(separatedBy: " ")
      var initials = ""
      
      for component in nameComponents {
         if let firstCharacter = component.first {
            initials.append(firstCharacter)
         }
      }
      
      return initials
   }
   
   func splitFullName() -> (String, String) {
      let components = self.components(separatedBy: " ")
      
      if components.count == 1 {
         return (self, "")
      } else {
         let firsName = components.first ?? ""
         let lastName = components.dropFirst().joined(separator: " ")
         return (firsName, lastName)
      }
   }
}
