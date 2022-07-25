//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Denis Evdokimov on 7/18/22.
//

import XCTest
@testable import Navigation

class NavigationTests: XCTestCase {
    
    var bruteForceService: BruteForceServiceProtocol!
    var loginInspector: LoginViewCheckerDelegate!
    
    override func setUpWithError() throws {
        bruteForceService = BruteForceService()
        loginInspector = LoginInspector(loginservice: LoginServiceMoke())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBruteForceService() throws {
  
        let password = "123"
        bruteForceService.bruteForce(passwordToUnlock: password) { res in
            XCTAssertEqual(res, password)
        }
        
    }
    
    func testLoginInspectorSuccses() throws {
        loginInspector
        loginInspector.createUser(login: "", password: "") { result in
       
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class LoginServiceMoke: LoginServiceProtocol {

    func loginUserService(login: String?, password: String?, completion: @escaping Handler) {
        completion(.success("test"))
    }
    
    func createUserService(login: String?, password: String?, completion: @escaping Handler) {
        completion(.success("create"))
    }
    
    func autoLoginservice(completion: @escaping Handler) {
        completion(.success("login"))
    }
    
    
}






