//
//  AddContactsView.swift
//  Contacts App
//
//  Created by Lucian Cristea on 13.09.2023.
//

import UIKit

enum TableViewCellType: String, CaseIterable {
   case firstName = "firstName"
   case lastName = "lastName"
   case phone = "phone"
   case email = "email"
   
   func cellTitle() -> String? {
      switch self {
      case .firstName:
         return Constants.addFirstName
      case .lastName:
         return Constants.addLastName
      case .phone:
         return Constants.addPhone
      case .email:
         return Constants.addEmail
      }
   }
}

class AddContactsView: UIViewController {
   
   private let cellNibName = Constants.addContactsCellNibName
   var presenter: AddContactsPresenter?
   @IBOutlet weak var tableView: UITableView!
   var showAlert: UIAlertController?
   let button = UIButton()
   var contact: Contact?
   var formDictionary: [String:Any] = [:]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      presenter = AddContactsPresenter(view: self)
      setupTitle()
      setupTableView()
      setupSaveButton()
   }
   
   private func setupTitle() {
      let titleLabel = UILabel()
      titleLabel.text = Constants.addContactsTitle
      titleLabel.textColor = .black
      titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
      titleLabel.sizeToFit()
      let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
      spacer.width = 24
      let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
      navigationItem.leftBarButtonItems = [spacer, titleBarButtonItem]
   }
   
   private func setupTableView() {
      tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.rowHeight = UITableView.automaticDimension
      self.tableView.backgroundColor = .sectionBackground
   }
   
   private func setupSaveButton() {
      let button = UIButton(type: .custom)
      button.setTitle(contact != nil ? Constants.updateContactsBtn : Constants.saveContactsBtn, for: .normal)
      button.backgroundColor = .customGreen
      button.tintColor = .white
      button.layer.cornerRadius = 12
      button.clipsToBounds = true
      button.titleLabel?.font = FontUtility.customFont(ofSize: 17, ofName: .bold)
      
      button.layer.masksToBounds = false
      button.layer.shadowColor = UIColor.black.cgColor
      button.layer.shadowOpacity = 0.2
      button.layer.shadowOffset = CGSize(width: 0, height: 1)
      button.layer.shadowRadius = 1
      
      view.addSubview(button)
      
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         button.heightAnchor.constraint(equalToConstant: 48)
      ])
      
      button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
   }
   
   @objc func saveButtonTapped() {
      print(formDictionary)
      if formDictionary["firstName"] as? String == "" || formDictionary["firstName"] as? String == "" {
         presenter?.showAlert(title: Constants.addAlertInfoTitle, message: Constants.addAlertNoData, completion: {
            print("Empty Name")
         })
      } else if (formDictionary["phone"] != nil) && (formDictionary["phone"] as? String != "" && ((formDictionary["phone"] as? String)?.numbers.count ?? 0) > 0 && ((formDictionary["phone"] as? String)?.numbers.count ?? 0) < 10) {
            presenter?.showAlert(title: Constants.addAlertInfoTitle, message: Constants.addAlertInfoPhone, completion: {
               print("Phone Incomplet")
            })
      } else {
         let contactInfoEdit = ContactInfo(dictionary: formDictionary)
         CoreDataManager.shared.updateOrAddCachedObject(dataObject: contact, contactInfoEdit: contactInfoEdit) {
            self.presenter?.showAlert(title: Constants.addAlertInfoTitle, message: Constants.addAlertInfoComplete, completion: {
               self.navigationController?.popViewController(animated: true)
            })
         }
      }
   }
   
   func showAlertWithPop(title: String, message: String, viewControllerToPop: UIViewController?, completion: (() -> Void)?) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default) { _ in
         alertController.dismiss(animated: true, completion: {
            completion?()
         })
      }
      
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
   }
}

extension AddContactsView: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return TableViewCellType.allCases.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cellType = TableViewCellType.allCases[indexPath.row]
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellNibName, for: indexPath) as? AddContactCell else { return UITableViewCell() }
      cell.contentView.backgroundColor = .sectionBackground
      
      var (firstName, lastName) = ("","")
      if let contactName = contact?.name {
         (firstName, lastName) = contactName.splitFullName()
      }
      
      formDictionary["id"] = contact?.id
      formDictionary["gender"] = contact?.gender
      formDictionary["status"] = contact?.status
      
      switch cellType {
      case .firstName:
         cell.delegate = self
         cell.populate(cellType: cellType, textField: firstName)
         formDictionary[cellType.rawValue] = firstName
         return cell
      case .lastName:
         cell.delegate = self
         cell.populate(cellType: cellType, textField: lastName)
         formDictionary[cellType.rawValue] = lastName
         return cell
      case .phone:
         cell.delegate = self
         cell.populate(cellType: cellType, textField: contact?.phone)
         formDictionary[cellType.rawValue] = contact?.phone
         cell.textField.keyboardType = .numberPad
         cell.textField.placeholder = "07XX XXX XXX"
         return cell
      case .email:
         cell.delegate = self
         cell.populate(cellType: cellType, textField: contact?.email)
         formDictionary[cellType.rawValue] = contact?.email
         return cell
      }
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 117.0
   }
}

extension AddContactsView: AddContactCellDelegate {
   func phoneNumberCellDidUpdate(_ cell: TableViewCellType?, withPhoneNumber phoneNumber: String) {
      if cell?.rawValue == "phone" {
         formDictionary["phone"] = phoneNumber
      }
   }
   
   func textFieldDidChange(_ cell: TableViewCellType?, text: String) {
      if let cellType = cell {
         formDictionary[cellType.rawValue] = text
      }
   }
}

extension AddContactsView: AlertPresenter {
   func presentAlert(_ alertController: UIAlertController) {
      present(alertController, animated: true)
   }
}
