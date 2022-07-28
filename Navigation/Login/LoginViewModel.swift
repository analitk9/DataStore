
import Foundation
import Firebase


protocol LoginViewCheckerDelegate: AnyObject {
    typealias Handler = (Result<String, LoginError>)->Void
    func loginUser(login: String?, password: String?, completion: @escaping Handler)
    func createUser(login: String?, password: String?, completion: @escaping Handler)
    func autoLogin(completion: @escaping Handler)
   
}

class LoginViewModel {
    private(set) var state: LoginViewModelState = .initial {
        didSet {
            onStateChanged?(state) // сюда модель сообщает о изменении своего состояния
        }
    }
    let checkerDelegate: LoginViewCheckerDelegate
    var onStateChanged: ((LoginViewModelState) -> Void)?
    var toProfileVC: ((String, Bool)->Void)
    let localAuthService: LocalAuthorizationServiceProtocol
    var isSwitchTabBar = false
    
    init(loginChecker: LoginViewCheckerDelegate, localAuthService: LocalAuthorizationServiceProtocol, toProfileVC: @escaping ((String, Bool)->Void)){
        self.toProfileVC = toProfileVC
        self.checkerDelegate = loginChecker
        self.localAuthService = localAuthService
 
    }
    
    private func handlingResult(_ result: Result<String, LoginError>){
        switch result {
        case let .success(login):
            self.toProfileVC(login, isSwitchTabBar)
        case let .failure(error):
            self.state = .error(.fbError(error.errorDescription))
            
        }
    }
    
    func send(_ action: LoginViewControllerAction){
        switch action {
            
        case .bruteForceButtonPress:
            bruteForcePress()
            
        case let .createUserButtonPress(login, password):
            
            checkerDelegate.createUser(login: login, password: password) { result in
                self.handlingResult(result)
            }
            
        case let .loginButtonPress(login, password):
            checkerDelegate.loginUser(login: login, password: password) { result in
                self.handlingResult(result)
            }
        case .autoLogin:
            checkerDelegate.autoLogin{ result in
                self.handlingResult(result)
            }
        case .bioAuthButtonPress:
            localAuthService.AuthenticationWithBiometrics { result in
                self.handlingResult(result)
            }
        case .ready:
            localAuthService.authorizeIfPossible { possible in
                self.state = .isBioPossible(possible)
            }
            state = .setBioImage(localAuthService.BiometryType()) 
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

extension LoginViewModel: LocalNotificationsServiceDelegate {
    func notificationPressAccept() {
        checkerDelegate.autoLogin{ result in
            self.isSwitchTabBar = true
            self.handlingResult(result)
        }
    }
    
}

extension LoginViewModel{
    
    enum LoginViewControllerAction { //  состояния вью
        case loginButtonPress(String?, String?)
        case bruteForceButtonPress
        case createUserButtonPress(String?, String?)
        case autoLogin
        case bioAuthButtonPress
        case ready
    }
    
    enum LoginViewModelState { // состояния модели
        
        case initial
        case login
        case logout
        case passwordBruteForce(String)
        case error(LoginError)
        case loginWithBio
        case loginBioIfPossible(Bool)
        case isBioPossible(Bool)
        case setBioImage(AuthType)
        
    }
}
