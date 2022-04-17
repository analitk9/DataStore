//
//  FeedViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/17/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var viewModel: FeedViewModel

    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let passwordTextField: UITextField = {
        let textField = StatusTextField()
        textField.configure(with: "enter word")
        return textField
    }()
    
    let colorCkeckLabel: UILabel = {
        let label = UILabel()
        label.text = "     "
        label.backgroundColor = .gray
        return label
    }()
    
    init(model: FeedViewModel){
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Feed"
        view.addSubview(stack)
        configureStack()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in // тут мы принимаем от модели изменение ее состояния и реагируем на них
            guard let self = self else { return }
            switch state {
            case let .checkedPassword(checkResalt):
                self.colorCkeckLabel.backgroundColor =  checkResalt ? UIColor.green : UIColor.red
            default: break
                
            }
            
        }
    }
    func configureStack(){
        let _ =  ["Кнопка 1","Кнопка 2"].map { [weak self] txt in
            let but = StatusButton(frame: .zero, title: txt, tintColor: StatusButton.Constans.tintColor)
            but.configure()
            but.onTap = pushToPostVC
            self?.stack.addArrangedSubview(but)
            
        }
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(colorCkeckLabel)
        
        let _ : CustomButton = {
            let but = StatusButton(frame: .zero, title: "Press", tintColor: StatusButton.Constans.tintColor)
            but.configure()
            but.onTap = checkButtonPress
            stack.addArrangedSubview(but)
            return but
        }()
    }
    
    override func viewWillLayoutSubviews() {
        setupLayout()
    }
    
    func setupLayout(){
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func configureTabBarItem() {
        
        tabBarItem.title = "Feed"
        tabBarItem.image = UIImage(systemName: "newspaper.circle")
        tabBarItem.selectedImage = UIImage(systemName: "newspaper.circle.fill")
        tabBarItem.tag = 10
        
    }
    
    func pushToPostVC() {
        viewModel.send(.pressButtonToPostVC)
    }
    
    func checkButtonPress(){
        if let text = passwordTextField.text, !text.isEmpty {
            viewModel.send(.pressCheckPasswordButton(text))
        }
    }
    
    
}
