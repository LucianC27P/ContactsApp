//
//  APIService.swift
//  Contacts App
//
//  Created by Lucian Cristea on 10.09.2023.
//

import Foundation

enum ResultError: Error {
   case responseError
}

struct Services {
   private static func getResponse(at url: URL, completion: @escaping (Result<Data, ResultError>) -> Void) {
      let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
         if let data = data {
            completion(.success(data))
            return
         }
         guard error == nil else {
            completion(.failure(.responseError))
            return
         }
      })
      task.resume()
   }
   
   private static func getContacts(for url: URL, completion: @escaping(Result<[Contact], ResultError>) -> Void) {
      Services.getResponse(at: url) { result in
         if case .success(let data) = result {
            do {
               let jsonDecoder = JSONDecoder()
               let contactsResponse = try jsonDecoder.decode([ContactInfo].self, from: data)
               CoreDataManager.shared.checkAndAddObjectsIfNeeded(objectsToCheck: contactsResponse)
               let coreDataFromCache = CoreDataManager.shared.fetchCachedObjects()
               completion(.success(coreDataFromCache))
            } catch let error {
               print(String(describing: error))
               completion(.failure(.responseError))
            }
         }
      }
   }
   
   static func getContacts(completion: @escaping(Result<[Contact], ResultError>)-> Void) {
      let url = Constants.apiContactsUrl
      self.getContacts(for: url, completion: completion)
   }
   
   static func downloadImageData(completion: @escaping (Data?) -> Void) {
      guard let imageURL = URL(string: "https://picsum.photos/200/200") else {
         completion(nil)
         return
      }
      
      URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
         if let error = error {
            print("Error downloading image data: \(error)")
            completion(nil)
            return
         }
         
         completion(data)
      }.resume()
   }
}
