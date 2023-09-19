//
//  ServicesTests.swift
//  Contacts AppTests
//
//  Created by Lucian Cristea on 15.09.2023.
//

import XCTest
@testable import Contacts_App

final class ServicesTests: XCTestCase {

      func testGetContactsSuccess() {
          let jsonString = "[{\"id\": 1, \"name\": \"Lucian\"}]"
          let mockData = jsonString.data(using: .utf8)!

          let expectation = XCTestExpectation(description: "Fetch contacts successfully")

          Services.getContacts { result in
              switch result {
              case .success(let contacts):
                  XCTAssertFalse(contacts.isEmpty)
              case .failure(let error):
                  XCTFail("Expected success, but got error: \(error)")
              }
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 5.0)
      }

      func testDownloadImageDataSuccess() {
          let expectation = XCTestExpectation(description: "Download image data successfully")

          Services.downloadImageData { data in
              XCTAssertNotNil(data)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 5.0)
      }
  }
