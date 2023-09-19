//
//  AddContactsPresenterTests.swift
//  Contacts AppTests
//
//  Created by Lucian Cristea on 15.09.2023.
//

import XCTest
@testable import Contacts_App

class MockAlertPresenter: AlertPresenter {
    var presentedAlertController: UIAlertController?
    
    func presentAlert(_ alertController: UIAlertController) {
        presentedAlertController = alertController
    }
}

final class AddContactsPresenterTests: XCTestCase {

   func testShowAlert() {
       let mockAlertPresenter = MockAlertPresenter()
       
       let presenter = AddContactsPresenter(view: mockAlertPresenter)
       
       let title = "Test Title"
       let message = "Test Message"
       
       let expectation = XCTestExpectation(description: "Alert should be presented")
       
       presenter.showAlert(title: title, message: message) {
           expectation.fulfill()
       }
       
       XCTAssertNotNil(mockAlertPresenter.presentedAlertController)
       XCTAssertEqual(mockAlertPresenter.presentedAlertController?.title, title)
       XCTAssertEqual(mockAlertPresenter.presentedAlertController?.message, message)
   }
}
