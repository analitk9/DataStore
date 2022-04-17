//
//  PhotoCollectionCell.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/15/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func configure(with image: UIImage?){
        imageView.image = image
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        contentView.addSubview(imageView)
        [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
}
