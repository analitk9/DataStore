//
//  ExtentionUIView.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/3/21.
//

import UIKit

extension UIImage{
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UITextField {
    
    func indent(size:CGFloat) {
        let rect = CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height)
        self.leftView = UIView(frame: rect)
        self.leftViewMode = .always
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]){
        views.forEach { addSubview($0)}
    }
}

extension QualityOfService: CaseIterable {
    public static var allCases: [QualityOfService] {
        return [.userInteractive, .background, .utility , .userInitiated, .default]
    }
    
    
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    func localize()-> String {
      NSLocalizedString(self, comment: "")
    }
}


     
