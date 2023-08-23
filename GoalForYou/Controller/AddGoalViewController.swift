//
//  AddGoalViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/23.
//

import UIKit
import Firebase

class AddGoalViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    let db = Firestore.firestore()
    
    let goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    func configureUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.clipsToBounds = true
        
        descriptionTextField.layer.cornerRadius = 10
        descriptionTextField.clipsToBounds = true
        
        completeButton.layer.cornerRadius = 20
        completeButton.clipsToBounds = true
    }
    
    
    @IBAction func completeBtnTapped(_ sender: UIButton) {
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = formatter.string(from: currentDate)
        
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            return
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let goalData: [String: Any] = [
                "title": title,
                "description": description,
                "reminderDate": currentDateString
            ]
            
            db.collection("users").document(uid).collection("goals").addDocument(data: goalData) { (error) in
                if let e = error {
                    print("Error saving data to Firestore: \(e.localizedDescription)")
                }
                else {
                    print("Successfully saved data")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            print("로그인 되지 않았습니다.")
        }
    }
    
}
