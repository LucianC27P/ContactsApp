//
//  LoadingView.swift
//  Contacts App
//
//  Created by Lucian Cristea on 13.09.2023.
//

import UIKit

import UIKit

class LoadingView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        addSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
