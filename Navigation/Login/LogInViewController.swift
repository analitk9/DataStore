//
//  LogInViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/3/21.
//

import UIKit


protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) throws -> Bool
}

class LogInViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    var toProfileVC: ((String)->Void)?
    
    private var keyboardHelper: KeyboardHelper?
    let loginView = LogInView()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .onDrag
        
        return scroll
    }()
    
    private let errorAlertService = ErrorAlertService()
    
    init() {
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
    
     func loginButtonPress() {
        
         guard let delegate = delegate else { return }
         guard let loginText = loginView.loginText.text else { return }
         guard let passwordText = loginView.passwordText.text else { return }
     
         do {
            let res = try delegate.check(login: loginText, password: passwordText)
             if res {
                 toProfileVC?(loginText)
             }
         }catch  {
             let loginError = error as! LoginError
             let alert = errorAlertService.createAlert(loginError.errorDescription)
             present(alert,animated: true)
         }
     }
    
    
    func bruteForcePress (){
        loginView.spinnerView.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let bfService = BruteForceService()
            bfService.bruteForce(passwordToUnlock: "112233"){[weak self] pass in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.loginView.spinnerView.stopAnimating()
                    self.loginView.passwordText.isSecureTextEntry = false
                    self.loginView.passwordText.text = pass
                }
            }
        }
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
