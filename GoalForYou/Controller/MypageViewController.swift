//
//  MypageViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/22.
//

import UIKit
import Firebase

class MypageViewController: UIViewController {
    
    
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        logoutButton.layer.cornerRadius = 15
        logoutButton.clipsToBounds = true
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
