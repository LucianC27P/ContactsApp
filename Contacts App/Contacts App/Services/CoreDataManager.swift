//
//  CoreDataManager.swift
//  Contacts App
//
//  Created by Lucian Cristea on 12.09.2023.
//

import Foundation
import CoreData

class CoreDataManager {
   static let shared = CoreDataManager()
   
   lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "ContactsAppDataModel")
      container.loadPersistentStores { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      }
      return container
   }()
   
   private func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
         do {
            try context.save()
         } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
      }
   }
   
   private func cacheObjects(_ serverObjects: [ContactInfo]) {
      let context = persistentContainer.viewContext
      
      for serverObject in serverObjects {
         let coreDataObject = Contact(context: context)
         coreDataObject.id = Int64(serverObject.id)
         coreDataObject.name = serverObject.name
         coreDataObject.status = serverObject.status
         coreDataObject.email = serverObject.email
         coreDataObject.gender = serverObject.gender
         coreDataObject.phone = serverObject.phone
         if serverObject.status == "active" {
            downloadAndCacheImage(coreDataObject: coreDataObject)
         }
      }
      
      saveContext()
   }
   
   func fetchCachedObjects() -> [Contact] {
      let context = persistentContainer.viewContext
      let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
      
      do {
         let fetchedObjects = try context.fetch(fetchRequest)
         return fetchedObjects
      } catch {
         print("Error fetching data: \(error.localizedDescription)")
         return []
      }
   }
   
   func updateOrAddCachedObject(dataObject: Contact?, contactInfoEdit: ContactInfo, completion:@escaping() -> Void) {
      let context = persistentContainer.viewContext
      if let id = dataObject?.id {
         let matchingObjects = doesObjectExistInCoreData(uniqueIdentifier: "\(id)")
         print("\(id)")
         if matchingObjects {
            if let objectToUpdate = dataObject {
               objectToUpdate.name = contactInfoEdit.name
               objectToUpdate.email = contactInfoEdit.email
               objectToUpdate.phone = contactInfoEdit.phone
            }
         }
      } else {
         let coreDataObject = Contact(context: context)
         if let newId =  getNewId() {
            coreDataObject.id = newId
            coreDataObject.name = contactInfoEdit.name
            coreDataObject.email = contactInfoEdit.email
            coreDataObject.status = "active"
            downloadAndCacheImage(coreDataObject: coreDataObject)
         }
      }
      saveContext()
      completion()
   }
   
   func deleteAllData() {
      let context = CoreDataManager.shared.persistentContainer.viewContext
      
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contact")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
      do {
         try context.execute(deleteRequest)
         try context.save()
      } catch {
         print("Error deleting data: \(error)")
      }
   }
   
   func checkAndAddObjectsIfNeeded(objectsToCheck: [ContactInfo]) {
      for objectToCheck in objectsToCheck {
         let matchingObjects = doesObjectExistInCoreData(uniqueIdentifier: "\(objectToCheck.id)")
         
         if !matchingObjects {
            cacheObjects(objectsToCheck)
         } else {
            print("from cache")
         }
      }
      
      saveContext()
   }
   
   private func doesObjectExistInCoreData(uniqueIdentifier: String) -> Bool {
      let context = persistentContainer.viewContext
      
      let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %@", uniqueIdentifier)
      
      do {
         let matchingObjectsCount = try context.count(for: fetchRequest)
         return matchingObjectsCount > 0
      } catch {
         print("Error checking if the object exists in Core Data: \(error)")
         return false
      }
   }
   
    func downloadAndCacheImage(coreDataObject: Contact) {
      Services.downloadImageData() { data in
         DispatchQueue.global().async {
            coreDataObject.imageData = data
            print("ImageCached")
         }
      }
   }
   
   private func getNewId() -> Int64? {
      let context = persistentContainer.viewContext
      
      let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.fetchLimit = 1
      
      do {
         let results = try context.fetch(fetchRequest)
         if let highestObject = results.first {
            return highestObject.id + 1
         }
      } catch {
         print("Error fetching highest ID from Core Data: \(error)")
      }
      
      return nil
   }
}
