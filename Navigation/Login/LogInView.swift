//
//  LoginView.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/3/21.
//

import UIKit

class LogInView: UIView {
    
    private enum Constans{
        static let padding: CGFloat = 16
        static let imageHeight: CGFloat = 100
        static let logoInset: CGFloat = 120
    }
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.layer.cornerRadius = 10
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.clipsToBounds = true
        return stack
    }()
    
    let passWordStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constans.padding
        return stack
    }()

    let logoView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "logo")
        image.layer.cornerRadius = 15
        return image
        
    }()
    
    let logInButton: CustomButton = {
        let but = CustomButton(frame: .zero, title: "Log in", tintColor: .white)
        but.translatesAutoresizingMaskIntoConstraints = false
        let pixelImage = UIImage(named: "bluePixel")
        but.setBackgroundImage(pixelImage?.withAlpha(1.0), for: .normal)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .highlighted)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .selected)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .disabled)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        return but
    }()
    
    let spinnerView = UIActivityIndicatorView(style: .large)
    
    let bruteForceButton: CustomButton = {
        
        let but = CustomButton(frame: .zero, title: "Bruteforce", tintColor: .white)
        but.translatesAutoresizingMaskIntoConstraints = false
        let pixelImage = UIImage(named: "bluePixel")
        but.setBackgroundImage(pixelImage?.withAlpha(1.0), for: .normal)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .highlighted)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .selected)
        but.setBackgroundImage(pixelImage?.withAlpha(0.8), for: .disabled)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        return but
        
    }()
    
    let loginText: UITextField = {
        let login = UITextField()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.layer.borderColor = UIColor.lightGray.cgColor
        login.layer.borderWidth = 0.5
        login.placeholder = "Email or phone"
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        login.tintColor =  .lightGray
        login.autocapitalizationType = .none
        login.backgroundColor = .systemGray6
        login.returnKeyType = .done
        login.indent(size: 10)
        
        return login
    }()
    
    
    let passwordText: UITextField = {
        let pass = UITextField()
        pass.translatesAutoresizingMaskIntoConstraints = false
        pass.layer.borderColor = UIColor.lightGray.cgColor
        pass.layer.borderWidth = 0.5
        pass.placeholder = "Password"
        pass.textColor = .black
        pass.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        pass.tintColor =  .lightGray
        pass.autocapitalizationType = .none
        pass.backgroundColor = .systemGray6
        pass.isSecureTextEntry = true
        pass.returnKeyType = .done
        pass.indent(size: 10)
        
        return pass
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        passWordStack.addArrangedSubview(passwordText)
        passWordStack.addArrangedSubview(spinnerView)
        stack.addArrangedSubview(loginText)
        stack.addArrangedSubview(passWordStack)
        spinnerView.hidesWhenStopped = true
       
        addSubviews([stack, logoView, logInButton, bruteForceButton])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constans.logoInset),
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: Constans.imageHeight),
            logoView.widthAnchor.constraint(equalToConstant: Constans.imageHeight),
            logInButton.heightAnchor.constraint(equalToConstant: Constans.imageHeight / 2),
            loginText.heightAnchor.constraint(equalToConstant: Constans.imageHeight / 2),
            passwordText.heightAnchor.constraint(equalToConstant: Constans.imageHeight / 2),
            stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constans.padding),
            stack.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: Constans.logoInset),
            stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constans.padding),
            logInButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            logInButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: Constans.padding),
            logInButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            bruteForceButton.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor),
            bruteForceButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: Constans.padding),
            bruteForceButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            bruteForceButton.heightAnchor.constraint(equalToConstant: Constans.imageHeight / 2),
        ])
    }
}
