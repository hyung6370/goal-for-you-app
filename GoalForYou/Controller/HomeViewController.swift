//
//  HomeViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/23.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var GoalTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var goals: [Goal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoalTableView.register(UINib(nibName: "GoalTableViewCell", bundle: nil), forCellReuseIdentifier: "GoalsCell")
        GoalTableView.delegate = self
        GoalTableView.dataSource = self
        
        loadGoals()
        
        navigationItem.hidesBackButton = true
    }

    func loadGoals() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).collection("goals").order(by: "reminderDate", descending: false).addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("Error fetching data from Firestore: \(e.localizedDescription)")
                }
                else {
                    self.goals = []
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let newGoal = Goal(title: data["title"] as? String, description: data["description"] as? String, reminderDate: data["reminderDate"] as? String, uniqueId: document.documentID, done: data["done"] as? Bool ?? false)
                        self.goals.append(newGoal)
                    }
                    
                    DispatchQueue.main.async {
                        self.GoalTableView.reloadData()
                    }
                }
            }
        }
    }
    

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalTableViewCell
        
        let goal = goals[indexPath.row]
        cell.titleLabel.text = goal.title
        cell.descriptionLabel.text = goal.description
        
        cell.accessoryType = goal.done ? .checkmark : .none
        
        return cell
    }
}

extension HomeViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let goalVC = storyboard.instantiateViewController(withIdentifier: "GoalVC") as? GoalViewController {
            
            let selectedGoal = goals[indexPath.row]
            goalVC.goalTitle = selectedGoal.title
            goalVC.goalDescription = selectedGoal.description
            goalVC.goalDocumentId = selectedGoal.uniqueId
            
            self.navigationController?.pushViewController(goalVC, animated: true)
        }
    }
}


extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
