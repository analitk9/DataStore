//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/20/21.
//

import UIKit
import SnapKit
protocol tapAvatarViewProtocol {
    
    func tapHandler(_ gesture: UITapGestureRecognizer)
}

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    private var statusText: String?
    
    private enum Constans{
        static let padding: CGFloat = 16
        static let avatarViewSideSize: CGFloat = 110
        static let statusButtonHeight: CGFloat = 50
        static let statusTextFieldHeight: CGFloat = 40
        static let statusTextFieldHeightPadding: CGFloat = 34
    }
    
    let statusTextField: UITextField = {
        let field = StatusTextField(frame: .zero)
        
        field.configure(with: "Waiting for something...".localize())
        return field
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4"
        return label
    }()
    
    var tapAvatarViewDelegate: tapAvatarViewProtocol?
    
    let profileAvatarView: UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: Constans.avatarViewSideSize, height: Constans.avatarViewSideSize)
        let image = ProfileAvatarView(frame: rect)
        image.configure()
        return image
    }()
    
    let statusButton: StatusButton = {
        let button = StatusButton(frame: .zero, title: "Show status".localize(), tintColor: StatusButton.Constans.tintColor)
        button.configure()
        return button
    }()
    
    let statusTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something...".localize()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster Cat"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init( reuseIdentifier: String?) {
        super.init( reuseIdentifier: reuseIdentifier)
        
        statusButton.onTap = statusButtonPressed
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        statusTextField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        profileAvatarView.addGestureRecognizer(gesture)
        profileAvatarView.isUserInteractionEnabled = true
        
        
        contentView.addSubviews([statusTextLabel, profileNameLabel, profileAvatarView, statusButton, statusTextField,timerLabel])
        contentView.backgroundColor = UIColor.createColor(lightMode:  UIColor(red: 199/255, green: 198/255, blue: 205/255, alpha: 1), darkMode: .darkGray)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        profileAvatarView.snp.makeConstraints{make in
            make.leading.equalTo(contentView.snp.leading).offset(Constans.padding)
            make.top.equalTo(contentView.snp.top).offset(Constans.padding)
            make.size.equalTo(CGSize(width: Constans.avatarViewSideSize, height: Constans.avatarViewSideSize))
        }
        statusButton.snp.makeConstraints { make in
            make.height.equalTo(Constans.statusButtonHeight)
            make.leading.equalTo(contentView.snp.leading).offset(Constans.padding)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constans.padding)
            make.top.equalTo(profileAvatarView.snp.bottom).offset(Constans.padding*2)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarView.snp.trailing).offset(Constans.padding)
            make.top.equalTo(contentView.snp.top).offset(Constans.padding)
        }
        statusTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel.snp.leading)
        }
        statusTextField.snp.makeConstraints { make in
            make.height.equalTo(Constans.statusTextFieldHeight)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constans.padding)
            make.top.equalTo(statusTextLabel.snp.bottom).offset(Constans.padding)
            make.leading.equalTo(statusTextLabel.snp.leading)
            make.bottom.equalTo(statusButton.snp.top).offset(-Constans.statusTextFieldHeightPadding)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(Constans.padding)
            make.right.equalTo(-Constans.padding)
        }
        
    }
    
    func statusButtonPressed(){
        if let statusText = statusText {
            statusTextLabel.text = statusText
            statusTextField.resignFirstResponder()
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text
    }
    
    @objc func tapAvatar(_ gesture: UITapGestureRecognizer){
        guard let tapDelegate = tapAvatarViewDelegate else { return }
        tapDelegate.tapHandler(gesture)
    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

