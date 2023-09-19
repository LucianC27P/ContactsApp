//
//  ContactsView.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import UIKit

class ContactsView: UITableViewController {
   
   private let cellNibName = Constants.contactsCellNibName
   private let viewModel = ContactsViewModel()
   private let loadingView = LoadingView()
   private var selectedContact: Contact? = nil
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupTableView()
      setupNavigationItems()
      
      loadingView.show()
      view.addSubview(loadingView)
      loadingView.frame = view.bounds
      
      viewModel.loadingStateChanged = { [weak self] in
         DispatchQueue.main.async {
            self?.loadingView.hide()
            self?.tableView.tableFooterView?.isHidden = true
            self?.tableView.reloadData()
         }
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      tableView.tableFooterView = Spinner.createSpinnerFooter()
      tableView.tableFooterView?.isHidden = false
      selectedContact = nil
      viewModel.fetchData()
   }
   
   deinit {
      viewModel.loadingStateChanged = nil
   }
   
   private func setupTableView() {
      tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
      tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
   }
   
   private func setupNavigationItems() {
      
      let titleLabel = UILabel()
      titleLabel.text = Constants.contactsTitle
      titleLabel.textColor = .black
      titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
      titleLabel.sizeToFit()
      let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
      spacer.width = 16
      let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
      navigationItem.leftBarButtonItems = [spacer, titleBarButtonItem]
      
      let squareView = UIView()
      squareView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
      squareView.backgroundColor = .clear
      squareView.layer.cornerRadius = 5
      squareView.layer.borderWidth = 2.0
      squareView.layer.borderColor = UIColor.sectionBackground.cgColor
      
      let button = UIButton()
      button.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
      button.setImage(UIImage(named: Constants.addContactIcon), for: .normal)
      
      let buttonX = (squareView.bounds.size.width - button.bounds.size.width) / 2
      let buttonY = (squareView.bounds.size.height - button.bounds.size.height) / 2
      button.frame.origin = CGPoint(x: buttonX, y: buttonY)
      
      squareView.addSubview(button)
      
      let squareBarButtonItem = UIBarButtonItem(customView: squareView)
      navigationItem.rightBarButtonItem = squareBarButtonItem
      
      button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
   }
   
   @objc func buttonTapped() {
      performSegue(withIdentifier: Constants.contactsSegue, sender: self)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == Constants.contactsSegue {
         if let destinationVC = segue.destination as? AddContactsView {
            destinationVC.contact = selectedContact
         }
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfContacts()
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellNibName, for: indexPath) as? ContactCell else { return UITableViewCell() }
      
      if let contact = viewModel.getContact(at: indexPath.row){
         cell.populate(contact: contact)
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 38.0
   }
   
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView()
      headerView.backgroundColor = .sectionBackground
      
      let label = UILabel()
      label.text = Constants.contactsSectionTitle
      label.textColor = .textGray
      label.font = UIFont.boldSystemFont(ofSize: 13)
      headerView.addSubview(label)
      
      label.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
         label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24.0),
      ])
      
      return headerView
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 94.0
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      selectedContact = viewModel.getContact(at: indexPath.row)
      performSegue(withIdentifier: Constants.contactsSegue, sender: self)
   }
}
