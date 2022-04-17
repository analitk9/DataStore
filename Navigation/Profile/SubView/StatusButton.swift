//
//  StatusButton.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/24/21.
//

import UIKit

class StatusButton: CustomButton {
    enum Constans{
        static let cornerRadius: CGFloat = 15
        static let shadowOpacity: Float = 0.7
        static let backgroundColor: UIColor =  UIColor(red: 11/255 , green: 88/255, blue: 233/255, alpha: 1)
        static let tintColor: UIColor = .white
        static let shadowOffset: CGSize = CGSize(width: 4, height: 4)
        static let shadowColor: CGColor = UIColor.black.cgColor
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Constans.backgroundColor
        layer.cornerRadius = Constans.cornerRadius
        layer.shadowOffset = Constans.shadowOffset
        layer.shadowColor  = Constans.shadowColor
        layer.shadowOpacity = Constans.shadowOpacity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layer.shadowOffset = CGSize.zero
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        layer.shadowOffset = Constans.shadowOffset
    }
    
}
