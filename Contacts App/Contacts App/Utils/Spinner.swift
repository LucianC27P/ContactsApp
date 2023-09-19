//
//  Spinner.swift
//  Contacts App
//
//  Created by Lucian Cristea on 14.09.2023.
//

import Foundation
import UIKit

struct Spinner {
    static func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
