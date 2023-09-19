//
//  AddContactCell.swift
//  Contacts App
//
//  Created by Lucian Cristea on 13.09.2023.
//

import UIKit

protocol AddContactCellDelegate: AnyObject {
    func textFieldDidChange(_ cell: TableViewCellType?, text: String)
    func phoneNumberCellDidUpdate(_ cell: TableViewCellType?, withPhoneNumber phoneNumber: String)
}

class AddContactCell: UITableViewCell, UITextFieldDelegate {
  
   @IBOutlet weak var cellView: UIView!
   @IBOutlet weak var deviderView: UIView!
   @IBOutlet weak var textField: UITextField!
   @IBOutlet weak var fieldName: UILabel!
   weak var delegate: AddContactCellDelegate?
   var cellTypeValue: TableViewCellType?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      fieldName.textColor = .textGray
      
      textField.delegate = self
      textField.font = FontUtility.customFont(ofSize: 17, ofName: .regular)
      cellView.layer.cornerRadius = 12
      deviderView.backgroundColor = .sectionBackground
      textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
  }
   
   func populate(cellType: TableViewCellType?, textField: String?) {
      cellTypeValue = cellType
      self.fieldName.text = cellType?.cellTitle()
      self.textField.text = textField ?? ""
   }

   @objc func textFieldEditingChanged() {
      if cellTypeValue?.rawValue == "phone" {
         if let text = textField.text {
            let newNr = PhoneNumberFormatter.formatAndValidate(text)
            self.textField.text = newNr
            self.delegate?.phoneNumberCellDidUpdate(cellTypeValue, withPhoneNumber: newNr)
         }
      } else {
         if let text = textField.text {
            self.delegate?.textFieldDidChange(cellTypeValue, text: text)
         }
      }
   }
}
