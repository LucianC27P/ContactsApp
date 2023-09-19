//
//  Colors.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
       let redValue = CGFloat(red) / 255.0
       let greenValue = CGFloat(green) / 255.0
       let blueValue = CGFloat(blue) / 255.0
       self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
   }
   
   static var sectionBackground: UIColor {
      return UIColor(red: 239, green: 242, blue: 247, alpha: 1)
   }
   static var whiteBackground: UIColor {
      return .white
   }
   static var navigationBackground: UIColor {
      return UIColor(red: 184, green: 184, blue: 184, alpha: 0.3)
   }
   static var textBlack: UIColor {
      return UIColor(red: 22, green: 31, blue: 40, alpha: 1)
   }
   static var circleBackground: UIColor {
      return UIColor(red: 193, green: 200, blue: 215, alpha: 1)
   }
   static var textGray: UIColor {
      return UIColor(red: 152, green: 165, blue: 190, alpha: 1)
   }
   static var customGreen: UIColor {
      return UIColor(red: 44, green: 200, blue: 77, alpha: 1)
   }
}
