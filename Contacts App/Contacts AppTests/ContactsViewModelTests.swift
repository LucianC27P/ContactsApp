//
//  ContactsViewModelTests.swift
//  Contacts AppTests
//
//  Created by Lucian Cristea on 15.09.2023.
//

import XCTest
@testable import Contacts_App

final class ContactsViewModelTests: XCTestCase {
   
    func testFetchData() {
        let viewModel = ContactsViewModel()
        
        let expectation = XCTestExpectation(description: "Fetch data successfully")
        viewModel.fetchData()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
            XCTAssertFalse(viewModel.contacts.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetContact() {
        let viewModel = ContactsViewModel()
        viewModel.contacts = [Contact()]
        
        if let contact = viewModel.getContact(at: 0) {
            XCTAssertNotNil(contact)
        } else {
            XCTFail("Expected a valid contact")
        }

        let invalidContact = viewModel.getContact(at: 2)
        XCTAssertNil(invalidContact)
    }
    
    func testNumberOfContacts() {
        let viewModel = ContactsViewModel()

        viewModel.contacts = [Contact(), Contact()]

        XCTAssertEqual(viewModel.numberOfContacts(), 2)

        viewModel.contacts = []
        XCTAssertEqual(viewModel.numberOfContacts(), 0)
    }
}
