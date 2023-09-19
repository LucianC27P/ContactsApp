//
//  ContactCell.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import UIKit

class ContactCell: UITableViewCell {
   @IBOutlet weak var contactImageView: UIView!
   @IBOutlet weak var contactName: UILabel!
   @IBOutlet weak var arrowRight: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      contactName.textColor = .textBlack
      contactName.font = FontUtility.customFont(ofSize: 17.0, ofName: .bold)
      
      contactImageView.contentMode = .scaleAspectFill
      contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2
      contactImageView.clipsToBounds = true
      contactImageView.backgroundColor = .circleBackground
   }
   
   func populate(contact: Contact) {
      contactName.text = contact.name
      if(contact.status == "active") {
         if let imageData = contact.imageData {
            addImage(data: imageData)
         } else {
            addLabel(text: contact.name)
         }
      } else {
         addLabel(text: contact.name)
      }
   }
   
   func addImage(data: Data){
      for subview in contactImageView.subviews {
         subview.removeFromSuperview()
      }
      let imageView = UIImageView()
      imageView.frame = contactImageView.bounds
      imageView.contentMode = .scaleAspectFill
      imageView.image = UIImage(data: data)

      contactImageView.addSubview(imageView)
   }
   
   func addLabel(text: String?){
      for subview in contactImageView.subviews {
         subview.removeFromSuperview()
      }
      let label = UILabel()
      label.text = text?.extractInitials()
      label.textColor = .white
      label.textAlignment = .center
      label.font = UIFont.boldSystemFont(ofSize: 17)
      label.numberOfLines = 1 
      label.adjustsFontSizeToFitWidth = true
      label.textColor = .sectionBackground
      label.frame = contactImageView.bounds
      
      contactImageView.addSubview(label)
   }
}
