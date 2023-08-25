//
//  AddJourneyViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/25.
//

import UIKit
import Firebase

class AddJourneyViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var journeyTitleTextField: UITextField!
    @IBOutlet weak var journeyDescriptionTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    var uid: String? = Auth.auth().currentUser?.uid
    var goalDocumentId: String?
    var journeyDocumentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLatestGoalDocumentId { (goalId) in
            self.goalDocumentId = goalId
        }

        configureUI()
    }
    
    func configureUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        journeyTitleTextField.layer.cornerRadius = 10
        journeyTitleTextField.clipsToBounds = true
        
        journeyDescriptionTextField.layer.cornerRadius = 10
        journeyDescriptionTextField.clipsToBounds = true
        
        completeButton.layer.cornerRadius = 20
        completeButton.clipsToBounds = true
    }
    
    func fetchLatestGoalDocumentId(completion: @escaping (String?) -> Void) {
        guard let uid = uid else {
            completion(nil)
            return
        }

        db.collection("users").document(uid).collection("goals").order(by: "reminderDate", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            if let e = error {
                print("Goals를 가져오는 중 오류 발생: \(e.localizedDescription)")
                completion(nil)
            } else {
                if let latestGoal = snapshot?.documents.first {
                    completion(latestGoal.documentID)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = formatter.string(from: currentDate)
        
        guard let journeyTitle = journeyTitleTextField.text, !journeyTitle.isEmpty, let journeyDescription = journeyDescriptionTextField.text, !journeyDescription.isEmpty else {
            print("입력 칸이 비어 있습니다.")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("로그인 되지 않았습니다.")
            return
        }
        guard let goalId = goalDocumentId else {
            print("Goal Document ID가 없습니다.")
            return
        }
        
        let journeyData: [String: Any] = [
            "journeyTitle": journeyTitle,
            "journeyDescription": journeyDescription,
            "done": false,
            "journeyReminderDate": currentDateString
        ]
        
        
        db.collection("users").document(uid).collection("goals").document(goalId).collection("journeys").addDocument(data: journeyData) { error in
            
            if let e = error {
                print("Firestore에 Journey 데이터를 저장하는 중 오류 발생: \(e.localizedDescription)")
            }
            else {
                print("Journey가 성공적으로 저장되었습니다.")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
