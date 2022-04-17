//
//  ErrorAlertService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/9/22.
//

import UIKit

class ErrorAlertService {
  //  var textMessage: String?
    func createAlert(_ message: String)-> UIAlertController {
        let alertVC = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let button1 = UIAlertAction(title: "ОК", style: .default)
   
        alertVC.addAction(button1)

        return alertVC
    }
}
