//
//  Fonts.swift
//  Contacts App
//
//  Created by Lucian Cristea on 08.09.2023.
//

import UIKit

class FontUtility {
   enum SFProFontWeight: String {
       case regular = "SF-Pro-Display-Regular"
       case bold = "SF-Pro-Display-Bold"
       case semibold = "SF-Pro-Display-Semibold"
   }
   
   static func customFont(ofSize fontSize: CGFloat, ofName fontName: SFProFontWeight) -> UIFont {
      if let font = UIFont(name: fontName.rawValue, size: fontSize) {
           return font
       } else {
           return UIFont.systemFont(ofSize: fontSize)
       }
   }
}
