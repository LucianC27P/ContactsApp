//
//  AddContactsViewModel.swift
//  Contacts App
//
//  Created by Lucian Cristea on 13.09.2023.
//

import Foundation
import UIKit

protocol AlertPresenter: AnyObject {
   func presentAlert(_ alertController: UIAlertController)
}

class AddContactsPresenter {
   
   weak var view: AlertPresenter?
   
   init(view: AlertPresenter) {
      self.view = view
   }
   
   func showAlert(title: String, message: String, completion: (() -> Void)?) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default) { _ in
         alertController.dismiss(animated: true, completion: {
            completion?()
         })
      }
      alertController.addAction(okAction)
      
      view?.presentAlert(alertController)
   }
}
