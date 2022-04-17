//
//  ProfileAvatarView.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/24/21.
//

import UIKit

class ProfileAvatarView: UIImageView {
    private enum Constants{
        static let borderWidth: CGFloat = 1
    }

    func configure() {
        image =  UIImage(named: "cat")
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = Constants.borderWidth
    }
    

}
