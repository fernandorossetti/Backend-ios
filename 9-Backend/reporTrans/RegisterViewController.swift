//
//  RegisterViewController.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func register(sender: UIButton) {
        
        guard checkParams() else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: "Necesitas llenar todos los campos")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard passwordField.text == passwordConfirmationField.text else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: "Los password no son iguales")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        Request.sharedInstance.registerUser(emailField.text!, password: passwordField.text!) { (success, error) in
            if self.isValidEmail(String(self.emailField.text))
            { if success
            {
                let alert = Utils.sharedInstance.createAlert("Completado", message: "Sesion iniciada") { (alert) in
                    self.performSegueWithIdentifier("backAfterLoginSegue", sender: self)
                }
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = Utils.sharedInstance.createAlert("Error", message: error)
                self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }else
            {
                let alert = Utils.sharedInstance.createAlert("Error", message: "Campo Email invalido, recuerde usar @nombre.com")
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }

    
    func checkParams() -> Bool {
        guard !(passwordField.text?.isEmpty)! else {
            return false
        }
        
        guard !(passwordConfirmationField.text?.isEmpty)! else {
            return false
        }
        
        guard !(emailField.text?.isEmpty)! else {
            return false
        }
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    

}
