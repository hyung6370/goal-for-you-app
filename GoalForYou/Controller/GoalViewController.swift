//
//  GoalViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/24.
//

import UIKit
import Firebase

class GoalViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var journeys: [Journey] = []
    
    var goalTitle: String?
    var goalDescription: String?
    var goalDocumentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        addButtonCreated()
        fetchMain()
        
        itemTableView.register(UINib(nibName: "GoalTableViewCell", bundle: nil), forCellReuseIdentifier: "GoalsCell")
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadJourneys()
    }
    
    func loadJourneys() {
        guard let uid = Auth.auth().currentUser?.uid, let goalId = goalDocumentId else {
            print("UID or Goal Document ID is missing")
            return
        }
        
        db.collection("users").document(uid).collection("goals").document(goalId).collection("journeys").order(by: "journeyReminderDate").getDocuments { (snapshot, error) in
            if let e = error {
                print("Error fetching journeys from Firestore: \(e.localizedDescription)")
                return
            }
            
            self.journeys = []
            
            if let documents = snapshot?.documents {
                for doc in documents {
                    let data = doc.data()
                    if let journeyTitle = data["journeyTitle"] as? String, let journeyDescription = data["journeyDescription"] as? String {
                        let newJourney = Journey(journeyId: doc.documentID, journeyTitle: journeyTitle, journeyDescription: journeyDescription, done: data["done"] as? Bool ?? false)
                        self.journeys.append(newJourney)
                    }
                }
                self.itemTableView.reloadData()
            }
        }
    }
    
    func fetchMain() {
        mainTitle.text = goalTitle
        mainDescription.text = goalDescription
    }
    
    func addButtonCreated() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "9524ED")
    }
    
    @objc func addButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let addJourneyVC = storyboard.instantiateViewController(identifier: "AddJourneyVC") as? AddJourneyViewController {
    
            self.navigationController?.pushViewController(addJourneyVC, animated: true)
        }
    }
}


extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalTableViewCell
        
        let journey = journeys[indexPath.row]
        cell.titleLabel.text = journey.journeyTitle
        cell.descriptionLabel.text = journey.journeyDescription
        
        cell.accessoryType = journey.done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        journeys[indexPath.row].done = !journeys[indexPath.row].done
        
        updateJourneyDoneStatus(at: indexPath.row)
        
        itemTableView.reloadRows(at: [indexPath], with: .automatic)
        itemTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteJourney(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func deleteJourney(at indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid, let goalId = goalDocumentId else {
            print("UID 또는 Goal Document ID가 누락되었습니다.")
            return
        }
        
        let journey = journeys[indexPath.row]
        guard let journeyId = journey.journeyId else {
            print("Journey ID가 누락되었습니다.")
            return
        }
        
        let journeyRef = db.collection("users").document(uid).collection("goals").document(goalId).collection("journeys").document(journeyId)
        
        journeyRef.delete() { error in
            if let e = error {
                print("Journey 삭제 오류: \(e.localizedDescription)")
            }
            else {
                
                let alertController = UIAlertController(title: "기록 삭제", message: "해당 기록을 지우시겠습니까?", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    print("해당 Journey가 성공적으로 삭제되었습니다.")
                    self.journeys.remove(at: indexPath.row)
                    self.itemTableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    if self.journeys.allSatisfy({ $0.done }) {
                        self.updateGoalDoneStatus(uid: uid, goalId: goalId, isDone: true)
                    }
                    else {
                        self.updateGoalDoneStatus(uid: uid, goalId: goalId, isDone: false)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func updateJourneyDoneStatus(at index: Int) {
        guard let uid = Auth.auth().currentUser?.uid, let goalId = goalDocumentId else {
            print("UID 또는 Goal Document ID가 누락되었습니다.")
            return
        }
        
        let journey = journeys[index]
        guard let journeyId = journey.journeyId else {
            print("Journey ID가 누락되었습니다.")
            return
        }
        
        let journeyRef = db.collection("users").document(uid).collection("goals").document(goalId).collection("journeys").document(journeyId)
        
        journeyRef.updateData(["done": journey.done]) { (error) in
            if let e = error {
                print("journey의 done 상태 업데이트 오류: \(e.localizedDescription)")
            }
            else {
                print("Journey의 done 상태가 성공적으로 업데이트 되었습니다.")
                
                if self.journeys.allSatisfy({ $0.done }) {
                    self.updateGoalDoneStatus(uid: uid, goalId: goalId, isDone: true)
                }
                else {
                    self.updateGoalDoneStatus(uid: uid, goalId: goalId, isDone: false)
                }
            }
        }
    }
    
    func updateGoalDoneStatus(uid: String, goalId: String, isDone: Bool) {
        let goalRef = db.collection("users").document(uid).collection("goals").document(goalId)
        
        goalRef.updateData(["done": isDone]) { (error) in
            if let e = error {
                print("Goal의 done 상태 업데이트 오류: \(e.localizedDescription)")
            }
            else {
                print("Goal의 done 상태가 성공적으로 업데이트 되었습니다.")
            }
        }
    }
}
