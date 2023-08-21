//
//  RegisterViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    func configureUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.clipsToBounds = true
        
        pwTextField.layer.cornerRadius = 10
        pwTextField.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 20
        registerButton.clipsToBounds = true
    }

}
