//
//  RegisterViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    func configureUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
    }

}
