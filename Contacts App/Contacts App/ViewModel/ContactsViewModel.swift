//
//  ContactsViewModel.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import Foundation

class ContactsViewModel {
   var contacts: [Contact] = []
   var loadingStateChanged: (() -> Void)?
    
    
    init() {
      //CoreDataManager.shared.deleteAllData()
    }
   
    func fetchData() {
      Services.getContacts() { result in
         if case .success(let data) = result {
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
               self.contacts = data
               self.loadingStateChanged?()
            }
         }
      }
   }
   
    func getContact(at index: Int) -> Contact? {
        guard index >= 0, index < contacts.count else {
            return nil
        }
        return contacts[index]
    }
    
    func numberOfContacts() -> Int {
        return contacts.count
    }
}
