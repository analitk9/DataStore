
import Foundation
import Firebase
protocol LoginViewCheckerDelegate: AnyObject {
    func check(login: String?, password: String?) throws
    func loginUser(login: String?, password: String?, completion: @escaping(AuthDataResult?,Error?)-> Void)
    func createUser(login: String?, password: String?, completion: @escaping(AuthDataResult?,Error?)-> Void)
    func signOut()
}

class LoginViewModel {
    private(set) var state: LoginState = .initial {
        didSet {
            onStateChanged?(state) // сюда модель сообщает о изменении своего состояния
        }
    }
    var checkerDelegate: LoginViewCheckerDelegate
    var onStateChanged: ((LoginState) -> Void)?
    var toProfileVC: ((String)->Void)
    
    init(loginChecker: LoginViewCheckerDelegate,toProfileVC: @escaping ((String)->Void)){
        self.toProfileVC = toProfileVC
        checkerDelegate = loginChecker
        
    }
    
    func send(_ action: LoginAction){
        switch action {
            
        case .bruteForceButtonPress:
            bruteForcePress()
            
        case let .createUserButtonPress(login, password):
            checkerDelegate.createUser(login: login, password: password) { [weak self]   authResult, error in
                guard let self = self else { return }
                
                if error == nil {
                    self.toProfileVC(login!)
                    return
                }else {
                    self.state = .error(.fbError(error!.localizedDescription))
                }
            }
            
        case let .loginButtonPress(login, password):
            checkerDelegate.loginUser(login: login, password: password){ [weak self]   authResult, error in
                
                guard let self = self else { return }
                if error == nil {
                    
                    self.toProfileVC(login!)
                    return
                }else {
                    self.state = .error(.fbError(error!.localizedDescription))
                }
            }
        }
    }
    
    private func bruteForcePress (){
        DispatchQueue.global(qos: .background).async {
            let bfService = BruteForceService()
            bfService.bruteForce(passwordToUnlock: "123"){[weak self] pass in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.state = .passwordBruteForce(pass)
                }
            }
        }
    }
    
}

extension LoginViewModel{
    
    enum LoginAction { //  состояния вью
        case loginButtonPress(String?, String?)
        case bruteForceButtonPress
        case createUserButtonPress(String?, String?)
    }
    
    enum LoginState { // состояния модели
        
        case initial
        case login
        case logout
        case passwordBruteForce(String)
        
        case error(LoginError)
        
    }
}
