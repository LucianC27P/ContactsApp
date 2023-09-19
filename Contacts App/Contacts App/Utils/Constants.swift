//
//  Constants.swift
//  Contacts App
//
//  Created by Lucian Cristea on 10.09.2023.
//

import Foundation

struct Constants {
   static var apiContactsUrl = URL(string:"https://gorest.co.in/public/v2/users")!
   static var contactsTitle = "Contacte"
   static var contactsSectionTitle = "CONTACTELE MELE"
   static var addContactIcon = "addContactIcon"
   static var contactsSegue = "ContactsSegue"
   static var contactsCellNibName = "ContactCell"
   static var addContactsTitle = "Adaugă contact"
   static var saveContactsBtn = "Save"
   static var updateContactsBtn = "Update"
   static var addFirstName = "NUME"
   static var addLastName = "PRENUME"
   static var addPhone = "TELEFON"
   static var addEmail = "EMAIL"
   static var addContactsCellNibName = "AddContactCell"
   static var addAlertInfoTitle = "Info"
   static var addAlertNoData = "Campurile de NUME si PRENUME sunt obligatorii"
   static var addAlertInfoComplete = "Informatiile au fost salvate"
   static var addAlertInfoPhone = "Numar de telefon incomplet"
}
