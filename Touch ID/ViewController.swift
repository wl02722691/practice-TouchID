//
//  ViewController.swift
//  Touch ID
//
//  Created by 張書涵 on 2019/1/16.
//  Copyright © 2019 張書涵. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func touchIDclicked(_ sender: Any) {
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //This user can use the touch ID
            
            evaluatePolicy(content: context)
            
        }else {
            switch error!.code {
                
            case LAError.Code.touchIDNotEnrolled.rawValue:
                infoLabel.text = error?.localizedDescription ?? ""
                
            case LAError.Code.passcodeNotSet.rawValue:
                infoLabel.text = error?.localizedDescription ?? ""
                
            default:
                infoLabel.text = error?.localizedDescription ?? ""
                
            }
        }
    }
    
    func evaluatePolicy(content: LAContext) {
        content.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need to confirm your identity before we show you the secret image") { (success, error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    self.infoLabel.text = "You have been successfully authenticated"
                    self.performSegue(withIdentifier: "secret", sender: self)
                } else {
                    
                    switch error!._code {
                        
                    case LAError.Code.systemCancel.rawValue:
                        self.infoLabel.text = "System cancel"
                        
                    case LAError.Code.userCancel.rawValue:
                        self.infoLabel.text = "User cancels authentication"
                        
                    case LAError.Code.userFallback.rawValue:
                        self.infoLabel.text = "User chose to use password"
                    
                    self.checkPassword()
                        
                    default:
                        self.infoLabel.text = error?.localizedDescription ?? ""
                        
                    }
                }
            }
        }
    }
    @IBAction func unwind(segue: UIStoryboard) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkPassword() {
        
        let alert = UIAlertController(title: "Password", message: "What is your password", preferredStyle: .alert)
        
        let authenticateAction = UIAlertAction(title: "Authenticate", style: .default) { (action) in
            
            guard let textfield = alert.textFields?.first,
                let password = textfield.text else {
                    return
            }
            
            if (password == "alice so cute") {
                
                self.infoLabel.text = "Password successful"
                self.performSegue(withIdentifier: "secret", sender: self)
            
            } else {
                
                self.infoLabel.text = "incorrect password"
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(authenticateAction)
        
        present(alert,animated: true)
    }
    
}

