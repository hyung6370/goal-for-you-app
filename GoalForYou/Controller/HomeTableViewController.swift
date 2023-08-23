//
//  HomeTableViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/21.
//

import UIKit
import Firebase


class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var GoalTableView: UITableView!
    
    
    let db = Firestore.firestore()
    
    var goals: [Goal] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        GoalTableView.delegate = self
        GoalTableView.dataSource = self
    }
    
    func configureUI() {
        backView.layer.cornerRadius = 15
        backView.clipsToBounds = true
        backView.layer.borderWidth = 2
        backView.layer.borderColor = UIColor(hexCode: "b251e7").cgColor
    }
    
    func loadGoals() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).collection("goals").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("Error fetching data from Firestore: \(e.localizedDescription)")
                }
                else {
                    self.goals = []
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let newGoal = Goal(title: data["title"] as? String, description: data["description"] as? String, reminderDate: data["reminderDate"] as? String, uniqueId: document.documentID)
                        self.goals.append(newGoal)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
//    // MARK: - TableView DataSource Methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return goals.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//
//        let goal = goals[indexPath.row]
//        cell.titleLabel?.text = goal.title
//        cell.descriptionLabel?.text = goal.description
//
//
//        return cell
//    }
//
//
//
//    // MARK: - TableView Delegate Methods
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//
//    }
    


extension HomeTableViewController: UITableViewDelegate, UITableViewDataSource {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return goals.count
    }
    
    
}



