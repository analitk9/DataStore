//
//  StatusTextField.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/24/21.
//

import UIKit

class StatusTextField: UITextField {
    private enum Constants{
        static let cornerRadius: CGFloat = 12
        static let indent: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let fontSize: CGFloat = 15
    }
    func configure(with placeholder: String = "") {
        let currentFont = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
        font = currentFont
        textColor = .black
        backgroundColor = .white
        self.placeholder = placeholder
        self.indent(size: Constants.indent)
        leftViewMode = .always
        layer.cornerRadius = Constants.indent
        layer.borderWidth = Constants.borderWidth
        layer.borderColor =  UIColor.black.cgColor
        returnKeyType = .done
    }

}
