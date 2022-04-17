//
//  InfoViewController.swift
//  Navigation
//
//  Created by Denis Evdokimov on 10/17/21.
//

import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        createPostButton()
        title = "Info"
    }
    
    func createPostButton(){
        let button = CustomButton(frame: CGRect(x: (view.bounds.width / 2)-50,
                                                y: view.bounds.height / 2,
                                                width: 100, height: 50), title: "Alert", tintColor: nil)
        button.backgroundColor = .systemRed
        button.onTap = pressedAlertButton
        self.view.addSubview(button)
        
    }
    
    
    func pressedAlertButton (){
        let alertVC = UIAlertController(title: "Внимание", message: "Выберите действие", preferredStyle: .alert)
        let button1 = UIAlertAction(title: "Первое сообщение", style: .default){ _ in
            print("Первое сообщение")
        }
        let button2 = UIAlertAction(title: "Второе сообщение", style: .default){ _ in
            print("Второе сообщение")
        }
        let button3 = UIAlertAction(title: "exit info VC", style: .default){ _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(button1)
        alertVC.addAction(button2)
        alertVC.addAction(button3)
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
