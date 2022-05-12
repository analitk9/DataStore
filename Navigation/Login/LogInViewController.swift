//
//  LogInViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/3/21.
//

import UIKit


class LogInViewController: UIViewController {
    
    var loginViewModel: LoginViewModel
    
    private var keyboardHelper: KeyboardHelper?
    let loginView = LogInView()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .onDrag
        
        return scroll
    }()
    
    private let errorAlertService = ErrorAlertService()
    
    init(model: LoginViewModel) {
        loginViewModel = model
        super.init(nibName: nil, bundle: nil)
        
        configureTabBarItem()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(loginView)
        
        loginView.logInButton.onTap = loginButtonPress
        loginView.bruteForceButton.onTap = bruteForcePress
        loginView.createUserButton.onTap = createUserPress
        loginView.loginText.delegate = self
        loginView.passwordText.delegate = self
        
        keyboardHelper = KeyboardHelper { [unowned self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                let activeRect = loginView.logInButton.convert(loginView.logInButton.bounds, to: scrollView)
                let keyBoardFrame = view.convert(keyboardFrame, to: view.window)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardFrame.size.height, right: 0)
                scrollView.scrollIndicatorInsets = scrollView.contentInset
                scrollView.scrollRectToVisible(activeRect, animated: true)
            case .keyboardWillHide:
                scrollView.contentInset = .zero
                scrollView.scrollIndicatorInsets = .zero
            }
        }
        
        setupViewModel()
        loginViewModel.send(.autoLogin)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout(){
        [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            loginView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            loginView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            loginView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            loginView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func configureTabBarItem() {
        tabBarItem.title = "Profile"
        tabBarItem.image = UIImage(systemName: "person")
        tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        tabBarItem.tag = 20
    }
    
    private func setupViewModel(){
        loginViewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .login:
                print("VC login")
            case .logout:
                print("VC lgout")
            case let .error(error):
              let alert = self.errorAlertService.createAlert(error.errorDescription)
                self.present(alert,animated: true)
            case let .passwordBruteForce(pass):
                self.loginView.spinnerView.stopAnimating()
                self.loginView.passwordText.isSecureTextEntry = false
                self.loginView.passwordText.text = pass
            default:
                print("initial")
            }
        }
    }
    
    
    
     func loginButtonPress() {
          let loginText = loginView.loginText.text
          let passwordText = loginView.passwordText.text
         loginViewModel.send(.loginButtonPress(loginText, passwordText))
     }
    
    
    func bruteForcePress (){
        loginView.spinnerView.startAnimating()
        loginViewModel.send(.bruteForceButtonPress)
    }
    
    func createUserPress(){
        let loginText = loginView.loginText.text
        let passwordText = loginView.passwordText.text
        loginViewModel.send(.createUserButtonPress(loginText, passwordText))
    }
    
    
    func showWrongLoginPasswordAlert() {
        let alertVC = UIAlertController(title: "Внимание", message: "Не верно указан логи или пароль", preferredStyle: .alert)
        let button1 = UIAlertAction(title: "ОК", style: .default)
   
        alertVC.addAction(button1)

        self.present(alertVC, animated: true, completion: nil)        
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
