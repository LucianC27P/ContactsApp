//
//  ContactInfo.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import Foundation

public struct ContactInfo: Codable {
   var id: Int
   var name: String?
   var email: String?
   var gender: String?
   var status: String?
   var phone: String?
   
   public init(id: Int, name: String?, status: String?, email: String?, gender: String?, phone: String?) {
       self.id = id
       self.name = name
       self.status = status
       self.email = email
       self.gender = gender
       self.phone = phone
   }
   
   init(dictionary: [String: Any]) {
      self.id = dictionary["id"] as? Int ?? 0
      self.name = "\(dictionary["firstName"] ?? "") \(dictionary["lastName"] ?? "")"
      self.email = dictionary["email"] as? String
      self.gender = dictionary["gender"] as? String
      self.status = dictionary["status"] as? String
      self.phone = "\(dictionary["phone"] ?? "")"
   }
}
