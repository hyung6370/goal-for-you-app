//
//  LoginViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        keyboardGesture()
    }
    
    func keyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.clipsToBounds = true
        
        pwTextField.layer.cornerRadius = 10
        pwTextField.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = pwTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }
                else {
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
              
            }
        }
        
        
    }
    
}
