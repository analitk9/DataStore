//
//  CustomButton.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/19/22.
//

import UIKit

import UIKit
 class CustomButton: UIButton {

    var onTap: (() -> Void)?
    
    convenience init(frame: CGRect, title: String?, tintColor: UIColor?) {
        self.init(frame: frame)
        self.setTitle(title, for: .normal)
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func buttonTapped() {
        onTap?()
    }
}

