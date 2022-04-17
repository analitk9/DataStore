//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/26/22.
//

import Foundation

class FeedViewModel {
    
    private(set) var state: State = .initial {
        didSet {
           onStateChanged?(state) // сюда модель сообщает о изменении своего состояния
        }
    }
    var onStateChanged: ((State) -> Void)?
    var toPostVС: (() -> Void)? // переход на контроллер поста
    private let passwordCheckerModel = PasswordCheckerService(password: "pass")
    
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(checkWord), name:
                                                NSNotification.Name(NSNotification.checkPassword), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name:
                                                    NSNotification.Name(NSNotification.checkPassword), object: nil)
    }
    
    func send(_ action: Action){
        switch action {
       
        case let .pressCheckPasswordButton(word):
            passwordCheckerModel.check(word: word)
        
        case .pressButtonToPostVC:
            toPostVС?()
        }
    }
    
    @objc func checkWord(notification: Notification){
        if let rez = notification.object as? Bool {
            state = .checkedPassword(rez)
        }
    }
}

extension FeedViewModel {

    enum Action { //  состояния вью

        case pressCheckPasswordButton(String)
        case pressButtonToPostVC
    }

    enum State { // состояния модели
       
        case initial
        case checkedPassword(Bool)
        case error(String)

    }
}
