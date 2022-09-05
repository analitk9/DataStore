//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/15/21.
//

import UIKit


class PhotosTableViewCell: UITableViewCell {
    
    private enum Constans{
        static let padding: CGFloat = 12
        static let cornerRadius: CGFloat = 6
        static let spacing: CGFloat = 8
        static let allOffset: CGFloat = spacing * 3 + padding * 4
    }
    
    var tapHandler: (() -> Void)?
    
    private lazy var image1: UIImageView = {
        let photo = UIImageView(frame: .zero)
        photo.frame = .zero
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        photo.layer.cornerRadius = Constans.cornerRadius
        return photo
    }()
    private lazy var image2: UIImageView = {
        let photo = UIImageView(frame: .zero)
        photo.frame = .zero
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        photo.layer.cornerRadius = Constans.cornerRadius
        return photo
    }()
    private lazy var image3: UIImageView = {
        let photo = UIImageView(frame: .zero)
        photo.frame = .zero
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        photo.layer.cornerRadius = Constans.cornerRadius
        return photo
    }()
    private lazy var image4: UIImageView = {
        let photo = UIImageView(frame: .zero)
        photo.frame = .zero
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        photo.layer.cornerRadius = Constans.cornerRadius
        return photo
    }()
    
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Photos".localize()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constans.spacing
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews([photoLabel, arrowImage,imageStack])
        imageStack.addArrangedSubview(image1)
        imageStack.addArrangedSubview(image2)
        imageStack.addArrangedSubview(image3)
        imageStack.addArrangedSubview(image4)
        configureLayout()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapArrow))
        arrowImage.addGestureRecognizer(tap)
        arrowImage.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        configureLayout()
        
    }
    
   func configureLayout(){
       let width = round(UIScreen.main.bounds.width - Constans.allOffset) / 4
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constans.padding),
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constans.padding),
            
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constans.padding),
            arrowImage.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
            
            imageStack.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: Constans.padding),
            imageStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constans.padding),
            imageStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constans.padding),
            imageStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -Constans.padding),
            imageStack.heightAnchor.constraint(equalToConstant: width)
        ])
        
    }
    
    func configure(with fourPhotos: [Photo]){
        image1.image = UIImage(named: fourPhotos[0].name)
        image2.image = UIImage(named: fourPhotos[1].name)
        image3.image = UIImage(named: fourPhotos[2].name)
        image4.image = UIImage(named: fourPhotos[3].name)
    }
    
    @objc func tapArrow(){

        tapHandler?()
    }
}
