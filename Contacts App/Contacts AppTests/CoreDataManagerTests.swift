//
//  CoreDataManagerTests.swift
//  Contacts AppTests
//
//  Created by Lucian Cristea on 15.09.2023.
//

import XCTest
import CoreData
@testable import Contacts_App

final class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var managedObjectContext: NSManagedObjectContext!
    var contactInfo: ContactInfo!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager()
        managedObjectContext = coreDataManager.persistentContainer.viewContext
    }

    override func tearDown() {
        coreDataManager = nil
        managedObjectContext = nil
        super.tearDown()
    }

   func testFetchCachedObjects() {
       let contact1 = Contact(context: managedObjectContext)
       contact1.name = "Lucian"
       let contact2 = Contact(context: managedObjectContext)
       contact2.name = "Lucian"

       try? managedObjectContext.save()
       let fetchedContacts = coreDataManager.fetchCachedObjects()

       XCTAssertEqual(fetchedContacts.count, 2)
   }

   func testUpdateCachedObject() {
       let contact = Contact(context: managedObjectContext)
       contact.name = "Lucian"

       try? managedObjectContext.save()

      coreDataManager.updateOrAddCachedObject(dataObject: contact, contactInfoEdit: ContactInfo(id: 1, name: "Updated Name", status: "active", email: "updated@example.com", gender: "potato", phone: "1234567890")) {
       }

       let updatedContact = managedObjectContext.object(with: contact.objectID) as? Contact

       XCTAssertEqual(updatedContact?.name, "Updated Name")
       XCTAssertEqual(updatedContact?.email, "updated@example.com")
       XCTAssertEqual(updatedContact?.phone, "1234567890")
   }

//   func testDeleteAllData() {
//       let contact1 = Contact(context: managedObjectContext)
//       contact1.name = "Lucian"
//       let contact2 = Contact(context: managedObjectContext)
//       contact2.name = "Lucian"
//
//       try? managedObjectContext.save()
//       coreDataManager.deleteAllData()
//
//       let fetchedContacts = coreDataManager.fetchCachedObjects()
//
//       XCTAssertEqual(fetchedContacts.count, 0)
//   }
}
